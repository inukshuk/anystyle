module AnyStyle
  class Feature
    class Dictionary < Feature
      attr_reader :dictionary

      def initialize(options = {})
        @dictionary = AnyStyle::Dictionary.create(options).open
      end

      def observe(token, alpha, offset, sequence)
        dictionary.tags(alpha.downcase)
      end
    end
  end
end
