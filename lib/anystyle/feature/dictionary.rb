module Anystyle
  class Feature
    class Dictionary < Feature
      def elicit(alpha:)
        dictionary.tags(alpha.downcase)
      end
    end
  end
end
