module Anystyle
  class Feature
    class Downcase < Feature
      def elicit(_, alpha:)
        if alpha.empty?
          :EMPTY
        else
          alpha.downcase
        end
      end
    end
  end
end
