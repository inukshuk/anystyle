module AnyStyle
  class Normalizer
    class Volume < Normalizer
      @keys = [:volume, :pages, :date]

      def normalize(item, **opts)
        map_values(item, [:volume]) do |_, volume|
          volume = StringUtils.strip_html volume

          unless item.key?(:date)
            unless volume.sub!(/([12]\d{3});|\(([12]\d{3})\)/, '').nil?
              append item, :date, $1 || $2
            end
          end

          case volume
          when /(?:^|\s)(\p{Lu}?\d+|[IVXLCDM]+)\s?\(([^)]+)\)(\s?\d+\p{Pd}\d+)?/
            volume = $1
            append item, :issue, $2
            append item, :pages, $3.strip unless $3.nil?
            volume
          when /(?:(\p{Lu}?\d+|[IVXLCDM]+)[\p{P}\s]+)?(?:nos?|nr|n°|nº|iss?|fasc)\.?\s?(.+)$/i
            volume = $1
            append item, :issue, $2.sub(/\p{P}$/, '')
            volume
          when /(\p{Lu}?\d+|[IVXLCDM]+):(\d+(\p{Pd}\d+)?)/
            volume = $1
            append item, (($3.nil? || item.key?(:pages)) ? :issue : :pages), $2
            volume
          when /(\p{Lu}?\d+|[IVXLCDM]+)[\.\/](\S+)/
            volume = $1
            append item, :issue, $2.sub(/\p{P}$/, '')
            volume
          when /(\d+) [Vv]ol/
            $1
          else
            volume
              .sub(/<\/?(italic|i|strong|b|span|div)>/, '')
              .sub(/^[\p{P}\s]+/, '')
              .sub(/^[Vv]ol(ume)?[\p{P}\s]+/, '')
              .sub(/\p{P}$/, '')
          end
        end
      end
    end
  end
end
