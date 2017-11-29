module AnyStyle
  class Feature
    class Dictionary < Feature
      attr_reader :dictionary

      def initialize(dictionary:)
        @dictionary = dictionary
      end

      def elicit(token, alpha, offset, sequence)
        dictionary.tags(alpha.downcase)
      end
    end
  end
end
