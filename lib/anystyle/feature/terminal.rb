module AnyStyle
  class Feature
    class Terminal < Feature
      def observe(token, alpha, offset, sequence)
        case token
        when /[!\?\.]$/
          :terminal
        when /[,;:-]$/
          :internal
        else
          :none
        end
      end
    end
  end
end
