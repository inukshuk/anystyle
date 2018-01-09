module AnyStyle
  require 'namae'

  class Normalizer
    class Names < Normalizer
      @keys = [:author, :editor, :translator, :director]

      attr_accessor :namae

      def initialize(**options)
        super(**options)

        @namae = Namae::Parser.new({
          prefer_comma_as_separator: true,
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
          .gsub(/^\p{^Alpha}|[\p{Alpha}\.]$/, '')
      end

      def parse(value)
        namae.parse!(value).map { |name|
          name.normalize_initials
          name.to_h.reject { |_, v| v.nil? }
        }
      end
    end
  end
end
