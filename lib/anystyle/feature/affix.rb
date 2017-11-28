module Anystyle
  class Feature
    class Affix < Feature
      attr_reader :size

      def initialize(size: 4, prefix: true, suffix: false)
        @size, @suffix = size, (suffix || !prefix)
      end

      def elicit(token, *args)
        build(extract(token)) { |chars| join(chars) }
      end

      def extract(token)
        if suffix?
          token.chars.reverse.take(size)
        else
          token.chars.take(size)
        end
      end

      def join(chars)
        if suffix?
          chars.reverse.join('')
        else
          chars.join('')
        end
      end

      def build(chars)
        (1..size).map { |n| yield chars.take(n) }
      end

      def suffix?
        !!@suffix
      end

      def prefix?
        !suffix?
      end
    end
  end
end
