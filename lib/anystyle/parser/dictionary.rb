module Anystyle
  module Parser

    class Dictionary
      @tags = [
        :male, :female, :surname, :month, :place, :publisher, :journal
      ]

      @code = Hash[
        *@tags.zip(0.upto(@tags.length-1).map { |i| 2**i }).flatten
      ]

      @tags.freeze
      @code.freeze

      @defaults = {
        adapter: :hash,
        source: File.expand_path('../support/dict.txt.gz', __FILE__)
      }

      class << self
        attr_reader :tags, :code, :defaults, :adapters

        def create(options = {})
          options = options.merge defaults

          case options[:adapter]
          when :hash
            new options
          when :lmdb
            require 'lib/anystyle/parser/dictionary/lmdb'
            LMDB.new options
          when :redis
            require 'lib/anystyle/parser/dictionary/redis'
            Redis.new options
          else
            raise ArgumentError, "unknown adapter: #{options[:adapter]}"
          end
        end
      end

      attr_reader :db, :options

      def initialize(options)
        @options = options
      end

      def open
        begin
          @db = {} unless open?
          self
        ensure
          populate! if empty?
        end
      end

      def close
        @db = nil
      end

      def truncate
        close
      end

      def open?
        !db.nil?
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
          (value & Dictionary.code[tag] > 0) ? tag : :"no-#{tag}"
        }.unshift(value)
      end

      def populate!
        require 'zlib'

        File.open(options[:source], 'rb') do |file|
          mode = 0

          Zlib::GzipReader.new(file, encoding: 'UTF-8').each do |line|
            line.strip!

            if line.start_with?('#')
              case line
              when /^## (?:male|female|surname|last|chinese)/i
                mode = Dictionary.code[:surname]
              when /^## month/i
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
              value = get key
              put key, value + mode unless value > mode
            end
          end
        end
      end
    end
  end
end
