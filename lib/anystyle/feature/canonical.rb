module AnyStyle
  class Feature
    class Canonical < Feature
      def observe(token, alpha, *args)
        if alpha.empty?
          :BLANK
        else
          canonize alpha
        end
      end
    end
  end
end
