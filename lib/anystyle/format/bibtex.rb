module AnyStyle
  module Format
    module BibTeX
      TYPES = {
        'article-journal' => 'article',
        'chapter' => 'incollection',
        'manuscript' => 'unpublished',
        'paper-conference' => 'inproceedings',
        'report' => 'techreport'
      }

      def format_bibtex(dataset, **opts)
        require 'bibtex'

        b = ::BibTeX::Bibliography.new
        format_hash(dataset).each do |hash|
          flatten_values hash, skip: Normalizer::Names.keys

          if hash.key?(:type)
            hash[:bibtex_type] = TYPES[hash[:type]] || hash[:type]
            hash.delete :type
          else
            hash[:bibtex_type] = 'misc'
          end

          case hash[:bibtex_type]
          when 'article'
            rename_value hash, :'container-title', :journal
            rename_value hash, :issue, :number
          when 'techreport'
            rename_value hash, :publisher, :institution
          when 'thesis'
            rename_value hash, :publisher, :school
          end

          Normalizer::Names.keys.each do |role|
            names_to_bibtex hash, role
          end

          rename_value hash, :'collection-title', :series
          rename_value hash, :'container-title', :booktitle
          rename_value hash, :accessed, :urldate
          rename_value hash, :genre, :type
          rename_value hash, :location, :address

          b << ::BibTeX::Entry.new(hash)
        end
        b
      end

      def names_to_bibtex(hash, role)
        if hash.key?(role)
          hash[role] = hash[role].map { |name|
            case
            when name.key?(:literal)
              name[:literal]
            when name.key?(:family) || name.key?(:given)
              name.values_at(:family, :suffix, :given).compact.join(', ')
            else
              nil
            end
          }.compact.join(' and ')
        end
      end
    end
  end
end
