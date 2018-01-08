require 'uri'

module AnyStyle
  class Feature
    class Locator < Feature
      def observe(token, *args)
        case token
        when /ISBN|Url|URL/,
             /10.\d{4,9}\/[-._;()\/:A-Z0-9]+/i,
             URI.regexp
          'T'
        else
          'F'
        end
      end
    end
  end
end
