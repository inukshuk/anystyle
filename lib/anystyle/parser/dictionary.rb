module Anystyle
  module Parser

    # Dictionary is a Singleton object that provides a key-value store of
    # the Anystyle Parser dictionary required for feature elicitation.
    # This dictionary acts essentially like a Ruby Hash object, but because
    # of the dictionary's size it is not efficient to keep the entire
    # dictionary in memory at all times. For that reason, Dictionary
    # creates a persistent data store on disk using LMDB; if the `lmdb`
    # Gem is not installed a Ruby Hash is used as a fall-back.
    #
    # Alternatively, you can use Redis as the dictionary data store by
    # installing `redis' gem (and optionally the `hiredis' gem).
    #
    # The database will be automatically created from the dictionary file
    # using the best available DBM the first time it is accessed. Once
    # database file exists, the database will be restored from file.
    # Therefore, if you make changes to the dictionary file, you will have
    # to delete the old database file for a new one to be created.
    #
    # Database creation in LMDB mode requires write permissions.
    # By default, the database will be created in the support directory of
    # the Parser; if you have installed the gem version of the Parser, you
    # may not have write permissions, but you can change the path in the
    # Dictionary's options.
    #
    # ## Configuration
    #
    # To set the database mode:
    #
    #     Dictionary.instance.options[:mode] # => the database mode
    #
    # For a list of database modes available in your environment consult:
    #
    #     Dictionary.modes # => [:lmdb, :redis, :hash]
    #
    # Further options include:
    #
    #     Dictionary.instance.options[:source] # => the zipped dictionary file
    #     Dictionary.instance.options[:file] # => the database file (lmdb)
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

      @modes = []

      Util.maybe_require 'lmdb' do
        @modes.push :lmdb
      end

      @modes.push :hash

      Util.maybe_require 'redis' do
        @modes.push :redis
        Util.maybe_require 'redis/namespace'
        Util.maybe_require 'redis/connection/hiredis'
      end

      @defaults = {
        :mode => @modes[0],
        :source => File.expand_path('../support/dict.txt.gz', __FILE__),
        :path => File.expand_path('../support', __FILE__),
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
        db[key.to_s] = value.to_s
      end

      def create
        case options[:mode]
        when :lmdb
          truncate
          @db = LMDB.new(path,
            mapsize: 4096 * 1024 * 10,
            writemap: true,
            mapasync: true
          ).database
          populate
          close
        else
          # nothing
        end
      end

      def truncate
        close
        return unless Dir.exists? path

        ['data.mdb', 'lock.mdb'].each do |mdb|
          mdb = File.join(path, mdb)
          File.unlink(mdb) if File.exists?(mdb)
        end
      end

      def open
        case options[:mode]
        when :lmdb
          at_exit { Anystyle.dictionary.close }
          create unless File.exists?(File.join(path, 'data.mdb'))
          @db = LMDB.new(path,
            mapsize: 4096 * 1024 * 10,
            writemap: true,
            mapasync: true
          ).database

        when :redis
          at_exit { Anystyle.dictionary.close }
          @db = Redis.new(options)

          if defined?(Redis::Namespace)
            @db = Redis::Namespace.new namespace, :redis => @db
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
        when @db.respond_to?(:database_env)
          @db.database_env.close
        when @db.respond_to?(:close)
          @db.close
        when @db.respond_to?(:quit)
          @db.quit
        end

        @db = nil
      end

      def path
        case options[:mode]
        when :lmdb
          options[:path]
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

      def namespace
        options[:namespace]
      end

      def populate
        require 'zlib'

        File.open(options[:source], 'rb') do |f|
          mode = 0
          puts 'populating dictionary...'
          Zlib::GzipReader.new(f, encoding: 'UTF-8').each do |line|
            line.strip!
            if line.start_with?('#')
              puts line
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
        puts 'dictionary populated'
      end

    end

  end
end
