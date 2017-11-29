module AnyStyle
  module Parser
    class Dictionary
      require 'redis'
      Util.maybe_require 'redis/namespace'

      class Redis < Dictionary
        @defaults = {
          namespace: 'anystyle',
          port: 6379
        }

        class << self
          attr_reader :defaults
        end

        def initialize(options = {})
          super(self.class.defaults.merge(options))
        end

        def open
          unless open?
            @db = ::Redis.new(options)

            unless namespace.nil? or not defined?(::Redis::Namespace)
              @db = ::Redis::Namespace.new namespace, redis: @db
            end
          end

          self
        ensure
          populate! if empty?
        end

        def close
          db.close
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
end
