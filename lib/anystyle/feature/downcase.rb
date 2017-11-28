module Anystyle
  class Feature
    class Downcase < Feature
      def elicit(token, alpha, offset, sequence)
        if alpha.empty?
          :EMPTY
        else
          alpha.downcase
        end
      end
    end
  end
end
