module Anystyle
  class Feature
    class Caps < Feature
      def elicit(_, alpha:)
        case alpha
        when /^\p{Lu}+$/
          :caps
        when /^\p{Lt}/
          :title
        when /^\p{Ll}/
          :lower
        when /^\p{Lu}/
          :upper
        else
          :other
        end
      end
    end
  end
end
