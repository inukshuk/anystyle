module AnyStyle
  class Normalizer
    class Container < Normalizer
      @keys = [:booktitle]

      def normalize(item)
        map_values(item) do |_, value|
          value.gsub(/^[Ii]n:?\s+/, '')
        end
      end
    end
  end
end
