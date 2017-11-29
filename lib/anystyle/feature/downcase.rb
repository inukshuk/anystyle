module AnyStyle
  class Feature
    class Downcase < Feature
      def elicit(_, alpha, *args)
        if alpha.empty?
          :BLANK
        else
          alpha.downcase
        end
      end
    end
  end
end
