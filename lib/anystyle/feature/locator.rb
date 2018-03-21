require 'uri'

module AnyStyle
  class Feature
    class Locator < Feature
      def observe(token, **opts)
        case token
        when /\b(DOI|doi|ISBN|Url|URL|PMCID|PMID|PMC\d+|PubMed)\b/,
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
