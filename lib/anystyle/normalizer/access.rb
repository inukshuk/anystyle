module AnyStyle
  class Normalizer
    class Access < Normalizer
      @keys = [:accessed]

      def normalize(item)
        each_value(item) do |_, value|
          value.gsub!(/(accessed|retrieved)[\s:]*/, '')
        end
      end
    end
  end
end
