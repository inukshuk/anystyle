module AnyStyle
  class Feature
    class Words < Feature
      attr_reader :dictionary

      def initialize(dictionary:, **opts)
        super(**opts)
        @dictionary = dictionary
      end

      def observe(token, **opts)
        words = token.scan(/[\p{L}\p{N}_-]+/).map { |word| canonize word }
        numbers = token.scan(/\d+(\.\d+)?/)
        counts = dictionary.tag_counts(words)

        [
          words.length,
          numbers.length,
          *counts.map { |cnt| ratio(cnt, words.length) }
        ]
      end
    end
  end
end
