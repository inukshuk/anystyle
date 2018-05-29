module AnyStyle
  class Normalizer
    class Edition < Normalizer
      @keys = [:edition]

      def normalize(item, **opts)
        map_values(item) do |_, value|
          value
            .gsub(/rev\./, 'revised')
            .gsub(/([eé]d(\.|ition)?|ausg(\.|abe)?)$/i, '')
            .strip
        end
      end
    end
  end
end
