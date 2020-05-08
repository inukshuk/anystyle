module AnyStyle
  module Format
    module CSL
      def format_csl(dataset, **opts)
        format_hash(dataset).map do |hash|
          dates_to_citeproc(hash, **opts) if hash.key?(:date)
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

      def dates_to_citeproc(hash, date_format: 'edtf', **opts)
        date, = *hash.delete(:date)

        case date_format.to_s
        when 'citeproc'
          hash[:issued] = begin
            require 'citeproc'
            ::CiteProc::Date.parse!(date.tr('X~', 'u?')).to_citeproc.symbolize_keys
          rescue
            { raw: date }
          end
        else
          hash[:issued] = date
        end
      end
    end
  end
end
