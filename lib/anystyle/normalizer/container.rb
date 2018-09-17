module AnyStyle
  class Normalizer
    class Container < Normalizer
      @keys = [:'container-title']

      def normalize(item, **opts)
        map_values(item) do |_, value|
          value
            .sub(/^[Ii]n(?::|\s+the)?\s+(\p{^Ll})/, '\1')
            .sub(/^收入/, '')
            .sub(/^(\w+ )?presented at (the )?/i, '')
        end
      end
    end
  end
end
