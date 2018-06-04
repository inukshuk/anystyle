module AnyStyle
  module Format
    module CSL
      def format_csl(dataset, **opts)
        format_hash(dataset).map do |hash|
          flatten_values hash, skip: Normalizer::Names.keys

          rename_value hash, :pages, :page
          rename_value hash, :location, :'publisher-place'
          rename_value hash, :url, :URL
          rename_value hash, :doi, :DOI
          rename_value hash, :pmid, :PMID
          rename_value hash, :pmcid, :PMCID

          Normalizer::Names.keys.each do |role|
            if hash.key?(role)
              hash[role].reject! { |name| name[:others] }
            end
          end

          hash
        end
      end

      alias_method :format_citeproc, :format_csl
    end
  end
end
