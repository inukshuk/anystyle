module AnyStyle
  class Normalizer
    class Volume < Normalizer
      @keys = [:volume, :pages, :date]

      def normalize(item)
        # TODO
        #if !hash.has_key?(:pages) && volume =~ /\D*(\d+):(\d+(?:[—–-]+)\d+)/
        #  hash[:volume], hash[:pages] = $1.to_i, $2
        #  hash = normalize_pages(hash)
        #else
        #  case volume
        #  when /\D*(\d+)\D+(\d+[\s\/&—–-]+\d+)/
        #    hash[:volume], hash[:number] = $1.to_i, $2
        #  when /(\d+)?\D+no\.\s*(\d+\D+\d+)/
        #    hash[:volume] = $1.to_i unless $1.nil?
        #    hash[:number] = $2
        #  when /(\d+)?\D+no\.\s*(\d+)/
        #    hash[:volume] = $1.to_i unless $1.nil?
        #    hash[:number] = $2.to_i
        #  when /\D*(\d+)\D+(\d+)/
        #    hash[:volume], hash[:number] = $1.to_i, $2.to_i
        #  when /(\d+)/
        #    hash[:volume] = $1.to_i
        #  end
        #end

        map_values(item, [:volume]) do |_, volume|
          case volume
          when /(\p{Lu}?\d+)\s?\(([^)]+)\)/
            append item, :issue, $2
            $1
          when /(?:(\p{Lu}?\d+)[\p{P}\s]+)?(n?:os?|nr|n°|nº|iss?)\.?\s?(.+)$/i
            volume = $1
            append item, :issue, $2.sub(/\p{P}$/, '')
            volume
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
