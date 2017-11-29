module AnyStyle
  class Feature
    class Caps < Feature
      def elicit(_, alpha, *args)
        case alpha
        when /^\p{Upper}$/
          :single
        when /^\p{Upper}\p{Lower}/
          :initial
        when /^\p{Upper}+$/
          :caps
        when /^\p{Lower}+$/
          :lower
        else
          :other
        end
      end
    end
  end
end
