module Anystyle
  module Parser

    require 'redis'
    Util.maybe_require 'redis/namespace'

    class RedisDictionary extend Dictionary
      def open
        unless open?
          @db = Redis.new(options)

          unless namespace.nil? or not defined?(Redis::Namespace)
            @db = Redis::Namespace.new namespace, redis: @db
          end
        end

        self
      ensure
        populate! if empty?
      end

      def close
        db.close unless not open?
      end

      def open?
        not db.nil?
      end

      def empty?
        open? and db.dbsize == 0
      end

      def get(key)
        db[key.to_s].to_i
      end

      def put(key, value)
        db[key.to_s] = value.to_i
      end

      def namespace
        options[:namespace]
      end
    end
  end
end
