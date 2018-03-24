module AnyStyle
  class Feature
    class Punctuation < Feature
      def observe(token, **opts)
        case token
        when /^\p{^P}+$/
          :none
        when /:/
          :colon
        when /\p{Pd}/
          :hyphen
        when /\./
          :period
        when /&/
          :amp
        else
          :other
        end
      end
    end
  end
end
