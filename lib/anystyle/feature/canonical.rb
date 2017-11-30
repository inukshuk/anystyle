module AnyStyle
  class Feature
    class Canonical < Feature
      def elicit(_, alpha, *args)
        if alpha.empty?
          :BLANK
        else
          canonize alpha
        end
      end
    end
  end
end
