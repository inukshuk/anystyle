module AnyStyle
  module Format
    module CSL
      def format_csl(dataset, symbolize_keys: false, **opts)
        format_hash(dataset, { symbolize_keys: symoblize_keys }).map do |hash|
          flatten_values hash
          rename_value hash, 'pages', 'page'
          rename_value hash, 'location', 'publisher-place'
          rename_value hash, 'url', 'URL'
          rename_value hash, 'doi', 'DOI'
          rename_value hash, 'pmid', 'PMID'
          rename_value hash, 'pmcid', 'PMCID'
          hash
        end
      end

      alias_method :format_citeproc, :format_csl
    end
  end
end
