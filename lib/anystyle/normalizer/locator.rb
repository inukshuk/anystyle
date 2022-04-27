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
            doi = doi_extract(value) if value =~ /doi\.org\//i
            append item, :doi, doi unless doi.nil?
            urls = URI.extract(value, %w(http https ftp ftps))
            if urls.empty?
              value
            else
              urls
            end
          when :doi
            doi_extract(value) || value
          else
            value
          end
        end
      end
    end

    def doi_extract(value)
      value[/10(\.(\d{4,9}\/[-._;()\/:A-Z0-9]+|1002\/\S+)|\/\p{Alnum}{3,})/i]
    end
  end
end
