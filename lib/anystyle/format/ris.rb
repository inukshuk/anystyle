module AnyStyle
  module Format
    module RIS
      def format_ris(dataset, **opts)
        format_hash(dataset).map { |entry| format_entry(entry) }.join("\n\n") + "\n"
      end

      def format_entry(entry)
        lines = []

        type = ris_type(entry[:type])
        lines << "TY  - #{type}"

        add_authors(lines, entry[:author])
        lines << "PY  - #{entry[:issued]}" if entry[:issued]
        lines << "TI  - #{entry[:title]}" if entry[:title]
        lines << "T2  - #{entry[:'container-title']}" if entry[:'container-title']
        lines << "PB  - #{entry[:publisher]}" if entry[:publisher]
        lines << "SN  - #{entry[:ISBN] || entry[:ISSN]}" if entry[:ISBN] || entry[:ISSN]
        lines << "DO  - #{entry[:DOI]}" if entry[:DOI]
        lines << "UR  - #{entry[:URL]}" if entry[:URL]
        lines << "ET  - #{entry[:edition]}" if entry[:edition]
        lines << "CY  - #{entry[:'publisher-place'] || entry[:location]}" if entry[:'publisher-place'] || entry[:location]
        lines << "VL  - #{entry[:volume]}" if entry[:volume]
        lines << "IS  - #{entry[:issue]}" if entry[:issue]
        lines << "SP  - #{entry[:page].to_s.split('-')[0]}" if entry[:page]
        lines << "EP  - #{entry[:page].to_s.split('-')[1]}" if entry[:page]&.include?("-")
        lines << "ER  -"

        lines.join("\n")
      end

      def ris_type(type)
        case type
        when 'book' then 'BOOK'
        when 'chapter' then 'CHAP'
        when 'article-journal' then 'JOUR'
        else 'GEN' # Generic
        end
      end

      def add_authors(lines, authors)
        return unless authors

        authors.each do |author|
          name = if author[:literal]
                   author[:literal]
                 elsif author[:family] || author[:given]
                   [author[:family], author[:given]].compact.join(', ')
                 else
                   nil
                 end
          lines << "AU  - #{name}" if name
        end
      end
    end
  end
end
