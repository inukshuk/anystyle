module AnyStyle
  require 'uri'

  class Normalizer
    class Locator < Normalizer
      @keys = [:isbn, :url]

      def normalize(item)
        map_values(item) do |label, value|
          case label
          when :isbn
            value[/[\d-]+/]
          when :url
            URI.extract(value)
          else
            value
          end
        end
      end
    end
  end
end
