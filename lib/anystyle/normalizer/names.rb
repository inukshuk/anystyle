module AnyStyle
  require 'namae'

  class Normalizer
    class Names < Normalizer
      @keys = [:author, :editor, :translator, :director]

      attr_reader :namae, :connector

      def initialize(connector: ' and ', **options)
        super(**options)
        @connector = connector
        @namae = Namae::Parser.new({
          prefer_comma_as_separator: true,
          appellation: /\A(?!x)x/,
          title: /\A(?!x)x/
        })
      end

      def normalize(item)
        map_values(item) do |value|
          begin
            parse(strip(value))
          rescue
            [{ literal: value }]
          end
        end
      end

      def strip(value)
        value.gsub(/^\p{^Alpha}|[\p{Alpha}\.]$/, '')
      end

      def parse(value)
        namae.parse!(value).map { |name|
          name.normalize_initials
          name.to_h.reject { |_, v| v.nil? }
        }.join(connector)
      end
    end
  end
end
