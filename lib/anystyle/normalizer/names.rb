module AnyStyle
  require 'namae'

  class Normalizer
    class Names < Normalizer
      @keys = [
        :author, :editor, :translator, :director, :producer
      ]

      attr_accessor :namae

      def initialize(**options)
        super(**options)

        @namae = Namae::Parser.new({
          prefer_comma_as_separator: true,
          separator: /\s*\b(and|&|;|und|y|e)\b\s*/i,
          appellation: /\A(?!x)x/,
          title: /\A(?!x)x/
        })
      end

      def normalize(item)
        map_values(item) do |_, value|
          begin
            parse(strip(value))
          rescue
            [{ literal: value }]
          end
        end
      end

      def strip(value)
        value
          .gsub(/^[Ii]n:?\s+/, '')
          .gsub(/^\p{^Alpha}|\p{^Alpha}$/, '')
          .gsub(/\b[Ee]d(s?\.|itors?|ited)\s+(by\s+)?/, '')
          .gsub(/\b([Hh]rsg|gg?\.|Herausgeber)\s+/, '')
          .gsub(/\b[Hh]erausgegeben von\s+/, '')
          .gsub(/\b((d|ein)er )?[Üü]ber(s\.|setzt|setzung|tragen|tragung) v(\.|on)\s+/, '')
          .gsub(/\b([Tt]rans(\.|lated|lation)|trad\.)(\s+by)?\s+/, '')
          .gsub(/\b([Dd]ir(\.|ected))(\s+by)?\s+/, '')
          .gsub(/\b([Pp]rod(\.|uce[rd]))(\s+by)?\s+/, '')
          .gsub(/\b([Pp]erf(\.|orme[rd]))(\s+by)?\s+/, '')
          .gsub(/\([^\)]*\)/, '')
          .gsub(/[;:]/, ',')
          .strip
      end

      def parse(value)
        others = value.sub!(
          /(\bet\s+(al|coll)\b|\bu\.\s*a\.|(\band|\&)\s+others).*$/, ''
        )

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
