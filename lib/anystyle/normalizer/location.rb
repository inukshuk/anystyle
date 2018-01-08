module AnyStyle
  class Normalizer
    class Location < Normalizer
      @keys = [:location]

      def normalize(item)
        map_values(item) do |_, value|
          location = strip value

          if !item.key?(:publisher) && location.include?(':')
            location, publisher = location.split(/\s*:\s*/)
            item[:publisher] = publisher
          end

          location
        end
      end

      def strip(string)
        string.gsub(/^\p{^Alnum}+|\p{^Alnum}+$/, '')
      end
    end
  end
end
