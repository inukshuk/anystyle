require 'uri'

module AnyStyle
  class Feature
    class Locator < Feature
      def observe(token, *args)
        case token
        when /ISBN|Url|URL/
        when /10.\d{4,9}\/[-._;()\/:A-Z0-9]+/i
        when URI.regexp
          1
        else
          0
        end
      end
    end
  end
end
