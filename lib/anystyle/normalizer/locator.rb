module AnyStyle
  require 'uri'

  class Normalizer
    class Locator < Normalizer
      @keys = [:isbn, :url]

      def normalize(item, **opts)
        map_values(item) do |key, value|
          case key
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
