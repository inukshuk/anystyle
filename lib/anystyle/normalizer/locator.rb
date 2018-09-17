module AnyStyle
  require 'uri'

  class Normalizer
    class Locator < Normalizer
      @keys = [:isbn, :url, :doi]

      def normalize(item, **opts)
        map_values(item) do |key, value|
          case key
          when :isbn
            value[/[\d-]+/]
          when :url
            doi = doi_extract(value)
            append item, :doi, doi unless doi.nil?
            URI.extract(value)
          when :doi
            doi_extract(value) || value
          else
            value
          end
        end
      end
    end

    def doi_extract(value)
      value[/10\.(\d{4,9}\/[-._;()\/:A-Z0-9]+|1002\/\S+)/i]
    end
  end
end
