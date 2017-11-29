module AnyStyle
  require 'gdbm'

  class Dictionary
    class GDBM < Dictionary
      @defaults = {
        path: File.expand_path('../../data/dict.db', __FILE__),
        mode: 0666,
        flags: ::GDBM::WRCREAT # | ::GDBM::NOLOCK
      }

      attr_reader :env

      def initialize(options = {})
        super(self.class.defaults.merge(options))
      end

      def open
        close
        @db = ::GDBM.new(*options.values_at(:path, :mode, :flags))
        self
      ensure
        populate! if empty?
      end

      def close
        db.close if open?
      end

      def open?
        !(db.nil? || db.closed?)
      end

      def empty?
        open? and db.empty?
      end

      def truncate
        close
        File.unlink(options[:path])
      end

      def get(key)
        db[key.to_s].to_i
      end

      def put(key, value)
        db[key.to_s] = value.to_i.to_s
      end
    end
  end
end
