module AnyStyle
  class Feature
    class Dictionary < Feature
      attr_reader :dictionary

      def initialize(dictionary: AnyStyle::Dictionary.create.open)
        @dictionary = dictionary
      end

      def observe(token, alpha, offset, sequence)
        dictionary.tags(alpha.downcase)
      end
    end
  end
end
