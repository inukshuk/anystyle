module AnyStyle
  class Feature
    class Locator < Feature
      def elicit(token, alpha, offset, sequence)
        case token
        when /retrieved/i
          :retrieved
        when /isbn/i
          :isbn
        when /^doi:/i
          :doi
        when /^url|http|www\.[\w\.]+/i
          :url
        else
          :none
        end
      end
    end
  end
end
