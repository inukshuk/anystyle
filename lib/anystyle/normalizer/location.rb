module AnyStyle
  class Normalizer
    class Location < Normalizer
      @keys = [:location]

      def normalize(item)
        map_values(item) do |_, value|
          location = value.gsub(/^[^[:alnum:]]+|[^[:alnum:]]+$/, '')

          if !item.has_key?(:publisher) && location =~ /:/
            location, publisher = location.split(/\s*:\s*/)
            item[:publisher] = [publisher]
          end

          location
        end
      end
    end
  end
end
