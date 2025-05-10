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
        lines << "PY  - #{unwrap(entry[:issued])}" if entry[:issued]
        lines << "TI  - #{unwrap(entry[:title])}" if entry[:title]
        lines << "T2  - #{unwrap(entry[:'container-title'])}" if entry[:'container-title']
        lines << "PB  - #{unwrap(entry[:publisher])}" if entry[:publisher]
        lines << "SN  - #{unwrap(entry[:ISBN] || entry[:ISSN])}" if entry[:ISBN] || entry[:ISSN]
        lines << "DO  - #{unwrap(entry[:DOI])}" if entry[:DOI]
        lines << "UR  - #{unwrap(entry[:URL])}" if entry[:URL]
        lines << "ET  - #{unwrap(entry[:edition])}" if entry[:edition]
        lines << "CY  - #{unwrap(entry[:'publisher-place'] || entry[:location])}" if entry[:'publisher-place'] || entry[:location]
        lines << "VL  - #{unwrap(entry[:volume])}" if entry[:volume]
        lines << "IS  - #{unwrap(entry[:issue])}" if entry[:issue]
        lines << "SP  - #{unwrap(entry[:page].to_s.split('-')[0])}" if entry[:page]
        lines << "EP  - #{unwrap(entry[:page].to_s.split('-')[1])}" if entry[:page]&.include?("-")
        lines << "ER  -"

        lines.join("\n")
      end

      # Extended RIS type mapping
      def ris_type(type)
        case type.to_s.downcase
        when 'book'            then 'BOOK'  # Book
        when 'chapter'         then 'CHAP'  # Book chapter
        when 'article-journal' then 'JOUR'  # Journal article
        when 'magazine-article', 'magazine' then 'MGZN'  # Magazine
        when 'newspaper-article', 'news'    then 'NEWS'  # Newspaper
        when 'conference-paper', 'proceedings-article' then 'CONF'  # Conference
        when 'manuscript'      then 'UNPB'  # Unpublished
        when 'thesis'          then 'THES'  # Thesis/dissertation
        when 'webpage', 'electronic', 'online' then 'ELEC'  # Electronic source
        when 'film'            then 'MPCT'  # Motion picture
        when 'report'          then 'RPRT'  # Technical report
        else 'GEN' # Generic fallback
        end
      end

      def unwrap(val)
        val.is_a?(Array) ? val.first : val
      end

      def add_authors(lines, authors)
        return unless authors

        authors.each do |author|
          name = if author[:literal]
                  author[:literal]
                elsif author[:family] || author[:given]
                  family = author[:family]
                  given = author[:given]&.gsub('.', '')

                  # Add space between adjacent uppercase initials (e.g., "HJ" => "H J")
                  given = given.gsub(/(?<=\A|\s)([A-Z])(?=[A-Z])/, '\1 ') if given

                  [family, given].compact.join(', ')
                else
                  nil
                end

          lines << "AU  - #{name}" if name
        end
      end
    end
  end
end