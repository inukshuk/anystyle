module AnyStyle
  module Format
    module BibTeX
      def format_bibtex(dataset)
        require 'bibtex'

        b = BibTeX::Bibliography.new
        format_hash(dataset).each do |hash|
          hash[:bibtex_type] = hash.delete(:type) || 'misc'

          hash[:type] = hash.delete :genre if hash.key?(:genre)
          hash[:address] = hash.delete :location if hash.key?(:location)
          hash[:urldate] = hash.delete :accessed if hash.key?(:accessed)

          if hash.key?(:authority)
            if [:techreport,:thesis].include?(hash[:bibtex_type])
              hash[:institution] = hash.delete :authority
            else
              hash[:organization] = hash.delete :authority
            end
          end

          b << BibTeX::Entry.new(hash)
        end
        b
      end
    end
  end
end
