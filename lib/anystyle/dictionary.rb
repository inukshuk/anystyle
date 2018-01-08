module AnyStyle
  class Dictionary
    @tags = [
      :name, :month, :place, :publisher, :journal
    ]

    @code = Hash[
      *@tags.zip(0.upto(@tags.length-1).map { |i| 2**i }).flatten
    ]

    @tags.freeze
    @code.freeze

    @defaults = {
      adapter: :gdbm,
      source: File.expand_path('../data/dict.txt.gz', __FILE__)
    }

    class << self
      attr_reader :tags, :code, :defaults, :adapters

      def create(options = {})
        options = defaults.merge options
        adapter = options.delete :adapter

        case adapter
        when :memory, :hash
          new options
        when :gdbm
          require 'anystyle/dictionary/gdbm'
          Dictionary::GDBM.new options
        when :lmdb
          require 'anystyle/dictionary/lmdb'
          Dictionary::LMDB.new options
        when :redis
          require 'anystyle/dictionary/redis'
          Dictionary::Redis.new options
        else
          raise ArgumentError, "unknown adapter: #{adapter}"
        end
      end
    end

    attr_reader :db, :options

    def initialize(options)
      @options = options
    end

    def open
      @db = {} unless open?
      self
    ensure
      populate! if empty?
    end

    def close
      @db = nil
    end

    def truncate
      close
    end

    def open?
      not db.nil?
    end

    def empty?
      db.empty?
    end

    def get(key)
      db[key.to_s].to_i
    end

    def put(key, value)
      db[key.to_s] = value.to_i
    end

    alias_method :[], :get
    alias_method :[]=, :put

    def tags(key)
      value = get key

      Dictionary.tags.map { |tag|
        (value & Dictionary.code[tag] > 0) ? 1 : 0
      }
    end

    def populate!
      require 'zlib'

      File.open(options[:source], 'rb') do |file|
        mode = 0

        Zlib::GzipReader.new(file, encoding: 'UTF-8').each do |line|
          line.strip!

          if line.start_with?('#')
            case line
            when /@(\w+)@/
              mode = Dictionary.code[$1.intern]
              if mode.nil?
                raise "Unknown mode #{$1} reading dictionary"
              end
            else
              # skip comments
            end
          else
            key = line.split(/\s+(\d+\.\d+)\s*$/)[0]
            put key, get(key) | mode
          end
        end
      end
    end
  end
end
