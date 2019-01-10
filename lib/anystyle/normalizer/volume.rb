module AnyStyle
  class Normalizer
    class Volume < Normalizer
      @keys = [:volume, :pages, :date]

      VOLNUM_RX = '(\p{Lu}?\d+|[IVXLCDM]+)'
      def normalize(item, **opts)
        map_values(item, [:volume]) do |_, volume|
          volume = StringUtils.strip_html volume

          unless item.key?(:date)
            unless volume.sub!(/([12]\d{3});|\(([12]\d{3})\)|\/([12]\d{3})/, '').nil?
              append item, :date, $1 || $2 || $3
            end
          end

          case volume
          when /(?:^|\s)#{VOLNUM_RX}\s?\(([^)]+)\)(\s?\d+\p{Pd}\d+)?/
            volume = $1
            append item, :issue, $2
            append item, :pages, $3.strip unless $3.nil?
            volume
          when /(?:#{VOLNUM_RX}
                (?:\.?\s*J(?:ahrgan)?g\.?)?
                [\p{P}\s]+)?(?:nos?|nr|n°|nº|iss?|fasc|heft|h)\.?\s?(.+)$/ix
            volume = $1
            append item, :issue, $2.sub(/\p{P}$/, '')
            volume
          when /#{VOLNUM_RX}:(\d+(\p{Pd}\d+)?)/
            volume = $1
            append item, (($3.nil? || item.key?(:pages)) ? :issue : :pages), $2
            volume
          when /#{VOLNUM_RX}[\.\/](\S+)/
            volume = $1
            append item, :issue, $2.sub(/\p{P}$/, '')
            volume
          when /(\d+) [Vv]ol/, /J(?:ahrgan)?g\.? (\d+)/
            $1
          else
            volume
              .sub(/<\/?(italic|i|strong|b|span|div)>/, '')
              .sub(/^[\p{P}\s]+/, '')
              .sub(/^[Vv]ol(ume)?[\p{P}\s]+/, '')
              .sub(/[\p{P}\p{Z}\p{C}]+$/, '')
          end
        end
      end
    end
  end
end
