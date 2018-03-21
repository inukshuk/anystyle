module AnyStyle
  class Feature
    class Canonical < Feature
      def observe(token, alpha:, **opts)
        if alpha.empty?
          :BLANK
        else
          canonize alpha
        end
      end
    end
  end
end
