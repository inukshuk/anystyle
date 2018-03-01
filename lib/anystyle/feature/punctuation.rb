module AnyStyle
  class Feature
    class Punctuation < Feature
      def observe(token, alpha, offset, sequence)
        case token
        when /^\p{^P}+$/
          :none
        when /.+:.+/
          :colon
        when /.+\p{Pd}.+/
          :hyphen
        when /.+\..+/
          :period
        else
          :other
        end
      end
    end
  end
end
