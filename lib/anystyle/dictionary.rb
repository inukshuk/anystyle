module AnyStyle
  class Dictionary
    @tags = [:name, :place, :publisher, :journal]

    @code = Hash[
      *@tags.zip(0.upto(@tags.length-1).map { |i| 2**i }).flatten
    ]

    @tags.freeze
    @code.freeze

    @defaults = {
      adapter: :gdbm,
      source: nil
    }

    class << self
      attr_reader :tags, :code, :defaults, :adapters

      def create(options = {})
        return options if options.is_a?(Dictionary)

        options = defaults.merge(options || {})
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
        when :marshal
          require 'anystyle/dictionary/marshal'
          Dictionary::Marshal.new options
        else
          raise ArgumentError, "unknown adapter: #{adapter}"
        end
      end

      def instance
        Thread.current['anystyle_dictionary'] ||= create.open
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
        (value & Dictionary.code[tag] > 0) ? 'T' : 'F'
      }
    end

    def tag_counts(keys)
      counts = Dictionary.tags.map { 0 }
      keys.each do |key|
        value = get(key)
        Dictionary.tags.each.with_index do |tag, idx|
          counts[idx] += 1 if (value & Dictionary.code[tag] > 0)
        end if value > 0
      end
      counts
    end

    def populate!
      require 'zlib'

      File.open(options[:source], 'rb') do |file|
        mode = 0

        Zlib::GzipReader.new(file, encoding: 'UTF-8').each do |line|
          line.strip!

          case line
          when /^#! (\w+)/i
            mode = Dictionary.code[$1.to_sym]
          when /^#/
            # skip comments
          else
            key = line.split(/\s+(\d+\.\d+)\s*$/)[0]
            put key, get(key) | mode
          end
        end
      end
    end
  end
end
