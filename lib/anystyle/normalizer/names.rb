module AnyStyle
  require 'namae'

  class Normalizer
    class Names < Normalizer
      @keys = [
        :author, :editor, :translator, :director, :producer
      ]

      attr_accessor :namae

      def initialize(**opts)
        super(**opts)

        @namae = Namae::Parser.new({
          prefer_comma_as_separator: true,
          separator: /\A(and|AND|&|;|und|UND|y|e)\s+/,
          appellation: /\A(?!x)x/,
          title: /\A(?!x)x/
        })
      end

      def normalize(item, prev: [], **opts)
        map_values(item) do |key, value|
          value.gsub!(/(^[\(\[]|[,;:\)\]]+$)/, '')
          case
          when repeater?(value) && prev.length > 0
            prev[-1].dig(key, 0) || prev[-1].dig(:author, 0) || prev[-1].dig(:editor, 0)
          else
            begin
              parse(strip(value))
            rescue
              [{ literal: value }]
            end
          end
        end
      end

      def repeater?(value)
        value =~ /^([\p{Pd}_*][\p{Pd}_* ]+|\p{Co})(,|:|\.|$)/
      end

      def strip(value)
        value
          .gsub(/^[Ii]n:?\s+/, '')
          .gsub(/\b[EÉeé]d(s?\.|itors?\.?|ited|iteurs?|ité)(\s+(by|par)\s+|\b|$)/, '')
          .gsub(/\b([Hh](rsg|gg?)\.|Herausgeber)\s+/, '')
          .gsub(/\b[Hh]erausgegeben von\s+/, '')
          .gsub(/\b((d|ein)er )?[Üü]ber(s\.|setzt|setzung|tragen|tragung) v(\.|on)\s+/, '')
          .gsub(/\b[Tt]rans(l?\.|lated|lation)(\s+by\b)?\s*/, '')
          .gsub(/\b[Tt]rad(ucteurs?|(uit|\.)(\s+par\b)?)\s*/, '')
          .gsub(/\b([Dd]ir(\.|ected))(\s+by)?\s+/, '')
          .gsub(/\b([Pp]rod(\.|uce[rd]))(\s+by)?\s+/, '')
          .gsub(/\b([Pp]erf(\.|orme[rd]))(\s+by)?\s+/, '')
          .gsub(/\*/, '')
          .gsub(/\([^\)]*\)?/, '')
          .gsub(/\[[^\]]*\)?/, '')
          .gsub(/[;:]/, ',')
          .gsub(/^\p{^L}+|\s+\p{^L}+$/, '')
          .gsub(/[\s,\.]+$/, '')
          .gsub(/,{2,}/, ',')
          .gsub(/\s+\./, '.')
      end

      def parse(value)
        raise ArgumentError if value.empty?

        others = value.sub!(
          /(,\s+)?((\&\s+)?\bet\s+(al|coll)\b|\bu\.\s*a\b|(\band|\&)\s+others).*$/, ''
        ) || value.sub!(/\.\.\.|…/, '')

        # Add surname/initial punctuation separator for Vancouver-style names
        # E.g. Rang HP, Dale MM, Ritter JM, Moore PK
        if value.match(/^(\p{Lu}[^\s,.]+)\s+([\p{Lu}][\p{Lu}\-]{0,3})(,|[.]?$)/)
          value.gsub!(/\b(\p{Lu}[^\s,.]+)\s+([\p{Lu}][\p{Lu}\-]{0,3})(,|[.]?$)/, '\1, \2\3')
        end

        names = namae.parse!(value).map { |name|
          name.normalize_initials
          name.to_h.reject { |_, v| v.nil? }
        }

        names << { others: true } unless others.nil?
        names
      end
    end
  end
end
