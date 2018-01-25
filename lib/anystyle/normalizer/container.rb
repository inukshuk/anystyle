module AnyStyle
  class Normalizer
    class Container < Normalizer
      @keys = [:'container-title']

      def normalize(item)
        map_values(item) do |_, value|
          value.gsub(/^[Ii]n:?\s+/, '')
        end
      end
    end
  end
end
