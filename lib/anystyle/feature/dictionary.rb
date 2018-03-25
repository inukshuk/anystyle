module AnyStyle
  class Feature
    class Dictionary < Feature
      attr_reader :dictionary

      def initialize(dictionary:, **opts)
        super(**opts)
        @dictionary = dictionary
      end

      def observe(token, alpha:, **opts)
        dictionary.tags(alpha.downcase)
      end
    end
  end
end
