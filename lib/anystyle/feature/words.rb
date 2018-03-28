module AnyStyle
  class Feature
    class Words < Feature
      attr_reader :dictionary

      TITLE_WORDS = %w{
        abstract
        acknowledgements
        appendix
        bibliography
        chapter
        cited
        contents
        figures
        introduction
        references
        section
        tables
        works
      }

      def initialize(dictionary:, **opts)
        super(**opts)
        @dictionary = dictionary
      end

      def observe(token, **opts)
        words = token.scan(/\S+/).map { |word| canonize word }.reject(&:empty?)
        numbers = token.scan(/\d+(\.\d+)?/)
        title = words.count { |word| TITLE_WORDS.include?(word) }
        counts = dictionary.tag_counts(words)

        [
          words.length,
          classify(words[0]),
          numbers.length,
          ratio(title, words.length),
          *counts.map { |cnt| ratio(cnt, words.length) }
        ]
      end

      def classify(word)
        case word
        when /^(\d+|[vx]?iii?|i?[vx]|)$/i
          :number
        when /\d/
          :numeric
        when nil
          :none
        else
          :alpha
        end
      end
    end
  end
end
