module Anystyle
  module Parser

    # Dictionary is a Singleton object that provides a key-value store of
    # the Anystyle Parser dictionary required for feature elicitation.
    # This dictionary acts essentially like a Ruby Hash object, but because
    # of the dictionary's size it is not efficient to keep the entire
    # dictionary in memory at all times. For that reason, Dictionary
    # creates a persistent data store on disk using Kyoto Cabinet; if
    # Kyoto Cabinet is not installed a Ruby Hash is used as a fall-back.
    #
    # Starting with version 0.1.0 Redis support was added. If you would
    # like to use Redis as the dictionary data store you can do so by
    # installing `redis' gem (and optionally the `hiredis' gem).
    #
    # The database will be automatically created from the dictionary file
    # using the best available DBM the first time it is accessed. Once
    # database file exists, the database will be restored from file.
    # Therefore, if you make changes to the dictionary file, you will have
    # to delete the old database file for a new one to be created.
    #
    # Database creation in Kyoto-Cabinet mode requires write permissions.
    # By default, the database
    # will be created in the support directory of the Parser; if you have
    # installed the gem version of the Parser, you may not have write
    # permissions, but you can change the path in the Dictionary's options.
    #
    # ## Configuration
    #
    # To set the database mode:
    #
    #     Dictionary.instance.options[:mode] # => the database mode
    #
    # For a list of database modes available in your environment consult:
    #
    #     Dictionary.modes # => [:kyoto, :redis, :hash]
    #
    # Further options include:
    #
    #     Dictionary.instance.options[:source] # => the zipped dictionary file
    #     Dictionary.instance.options[:cabinet] # => the database file (kyoto)
    #     Dictionary.instance.options[:path] # => the database socket (redis)
    #     Dictionary.instance.options[:host] # => dictionary host (redis)
    #     Dictionary.instance.options[:part] # => dictionary port (redis)
    #
    class Dictionary

      include Singleton

      @keys = [:male, :female, :surname, :month, :place, :publisher, :journal].freeze

      @code = Hash[*@keys.zip(0.upto(@keys.length-1).map { |i| 2**i }).flatten]
      @code.default = 0
      @code.freeze

      @modes = [:hash]

      begin
        require 'redis/connection/hiredis'
      rescue LoadError
        # ignore
      end

      begin
        require 'redis'
        @modes.push :redis

        require 'redis/namespace'

      rescue LoadError
        # info 'no redis support detected'
      end

      begin
        require 'kyotocabinet'
        @modes.push :kyoto
      rescue LoadError
        # info 'no kyoto-cabinet support detected'
      end

      @defaults = {
        :mode => @modes[0],
        :source => File.expand_path('../support/dict.txt.gz', __FILE__),
        :cabinet => File.expand_path('../support/dict.kch', __FILE__),
        :namespace => 'anystyle',
        :port => 6379
      }.freeze


      class << self
        attr_reader :keys, :code, :defaults, :modes
      end

      attr_reader :options

      def initialize
        @options = Dictionary.defaults.dup
      end

      def config(&block)
        block[options]
      end

      def [](key)
        db[key.to_s].to_i
      end

      def []=(key, value)
        db[key.to_s] = value
      end

      def create
        case options[:mode]
        when :kyoto
          truncate
          @db = KyotoCabinet::DB.new
          unless @db.open(path, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
            raise DatabaseError, "failed to create cabinet file #{path}: #{@db.error}"
          end
          populate
          close

        else
          # nothing
        end
      end

      def truncate
        close
        File.unlink(path) if File.exists?(path)
      end

      def open
        case options[:mode]
        when :kyoto
          at_exit { Anystyle.dictionary.close }

          create unless File.exists?(path)

          @db = KyotoCabinet::DB.new
          unless @db.open(path, KyotoCabinet::DB::OREADER)
            raise DictionaryError, "failed to open cabinet file #{path}: #{@db.error}"
          end

        when :redis
          at_exit { Anystyle.dictionary.close }
          @db = Redis.new(options)

          if options[:namespace] && defined?(Redis::Namespace)
            @db = Redis::Namespace.new options[:namespace], :redis => @db
          end

          populate unless populated?

        else
          @db = Hash.new(0)
          populate
        end

        @db
      end

      def open?() !!@db end

      def close
        case
        when @db.respond_to?(:close)
          @db.close
        when @db.respond_to?(:quit)
          @db.quit
        end

        @db = nil
      end

      def path
        case options[:mode]
        when :kyoto
          options[:cabinet] || options[:path]
        when :redis
          options[:path] || options.values_at(:host, :port).join(':')
        else
          'hash'
        end
      end

      def populated?
        !!self['__created_at']
      end

      private

      def db
        @db || open
      end

      def populate
        require 'zlib'

        File.open(options[:source], 'r:UTF-8') do |f|
          mode = 0

          Zlib::GzipReader.new(f).each do |line|
            line.strip!

            if line.start_with?('#')
              case line
              when /^## male/i
                mode = Dictionary.code[:male]
              when /^## female/i
                mode = Dictionary.code[:female]
              when /^## (?:surname|last|chinese)/i
                mode = Dictionary.code[:surname]
              when /^## months/i
                mode = Dictionary.code[:month]
              when /^## place/i
                mode = Dictionary.code[:place]
              when /^## publisher/i
                mode = Dictionary.code[:publisher]
              when /^## journal/i
                mode = Dictionary.code[:journal]
              else
                # skip comments
              end
            else
              key = line.split(/\s+(\d+\.\d+)\s*$/)[0]
              value = self[key]
              self[key] = value + mode if value < mode
            end
          end
        end

        self['__created_at'] = Time.now.to_s
      end

    end

  end
end
