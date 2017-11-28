module Anystyle
  class Feature
    class Caps < Feature
      def elicit(token, alpha, offset, sequence)
        case alpha
        when /^[[:upper:]]$/
          :single
        when /^[[:upper:]][[:lower:]]/
          :initial
        when /^[[:upper:]]+$/
          :all
        #when /^\p{Lu}+$/
        #  :caps
        #when /^\p{Lt}/
        #  :title
        #when /^\p{Ll}/
        #  :lower
        #when /^\p{Lu}/
        #  :single # :upper
        else
          :other
        end
      end
    end
  end
end
