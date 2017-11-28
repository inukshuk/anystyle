module Anystyle
  class Feature
    class Sequence < Feature
      attr_reader :size

      def initialize(size: 4, reverse: false, **options)
        super(**options)
        @size, @reverse = size, reverse
      end

      def elicit(token)
        build(extract(token)) { |chars| join(chars) }
      end

      def extract(token)
        if reverse?
          token.chars.reverse.take(size)
        else
          token.chars.take(size)
        end
      end

      def join(chars)
        if reverse?
          chars.reverse.join('')
        else
          chars.join('')
        end
      end

      def build(chars)
        (1..size).map { |n|
          yield chars.take(n).map(&method(:encode))
        }
      end

      def encode(char)
        char
      end

      def reverse?
        !!@reverse
      end
    end
  end
end
