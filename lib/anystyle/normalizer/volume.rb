module AnyStyle
  class Normalizer
    class Volume < Normalizer
      @keys = [:volume, :pages, :date]

      def normalize(item, **opts)
        map_values(item, [:volume]) do |_, volume|
          case volume
          when /(\p{Lu}?\d+)\s?\(([^)]+)\)\s?(\d+\p{Pd}\d+)?/
            append item, :issue, $2
            append item, :pages, $3 unless $3.nil?
            $1
          when /(?:(\p{Lu}?\d+)[\p{P}\s]+)?(?:nos?|nr|n°|nº|iss?)\.?\s?(.+)$/i
            volume = $1
            append item, :issue, $2.sub(/\p{P}$/, '')
            volume
          when /(\d+):(\d+(\p{Pd}\d+)?)/
            append item, (item.key?(:pages) ? :issue : :pages), $2
            $1
          else
            volume
              .sub(/^[\p{P}\s]+/, '')
              .sub(/.*vol(ume)?[\p{P}\s]+/i, '')
              .sub(/\p{P}$/, '')
          end
        end
      end
    end
  end
end
