module AnyStyle
  class Dictionary
    class Marshal < Dictionary
      @defaults = {
        path: File.expand_path('../../data/dict.marshal', __FILE__)
      }

      def initialize(options = {})
        super(self.class.defaults.merge(options))
      end

      def open
        if File.exist?(options[:path])
          @db = ::Marshal.load(File.open(options[:path]))
        else
          @db = {}
        end
        self
      ensure
        if empty?
          populate!
          if File.writable?(options[:path])
            ::Marshal.dump(db, File.open(options[:path], 'wb'))
          end
        end
      end
    end
  end
end
