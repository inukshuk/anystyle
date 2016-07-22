# -*- encoding: utf-8 -*-

module Anystyle
  module Parser

    class Normalizer

      include Singleton

      MONTH = Hash.new do |h,k|
        case k
        when /jan/i
          h[k] = 1
        when /feb/i
          h[k] = 2
        when /mar/i
          h[k] = 3
        when /apr/i
          h[k] = 4
        when /ma[yi]/i
          h[k] = 5
        when /jun/i
          h[k] = 6
        when /jul/i
          h[k] = 7
        when /aug/i
          h[k] = 8
        when /sep/i
          h[k] = 9
        when /o[ck]t/i
          h[k] = 10
        when /nov/i
          h[k] = 11
        when /dec/i
          h[k] = 12
        else
          h[k] = nil
        end
      end

      def method_missing(name, *arguments, &block)
        case name.to_s
        when /^normalize_(.+)$/
          normalize($1.to_sym, *arguments, &block)
        else
          super
        end
      end

      # Default normalizer. Strips punctuation.
      def normalize(key, hash)
        token, *dangling =  hash[key]
        unmatched(key, hash, dangling) unless dangling.empty?

        token.gsub!(/^[^[:alnum:]]+|[^[:alnum:]]+$/, '')

        hash[key] = token
        hash
      end

      def normalize_accessed(hash)
        token, *dangling =  hash[:accessed]
        unmatched(:accessed, hash, dangling) unless dangling.empty?

        token.gsub!(/(accessed|retrieved):?\s*/i, '')

        hash[:accessed] = token
        hash
      end

      def normalize_key(hash)
        token, *dangling =  hash[:key]
        unmatched(:key, hash, dangling) unless dangling.empty?

        token.gsub!(/^[^[:alnum:]]+|[^[:alnum:]]+$/, '')
        token.gsub!(/^bibitem\{/i, '')

        hash[:key] = token
        hash
      end

      def normalize_citation_number(hash)
        token, *dangling =  hash[:citation_number]
        unmatched(:citation_number, hash, dangling) unless dangling.empty?

        hash[:citation_number] = token[/\d[\w,.-]+/] || token
        hash
      end

      def normalize_author(hash)
        authors, *dangling = hash[:author]
        unmatched(:author, hash, dangling) unless dangling.empty?

        if authors =~ /\b[Ee]d((s|itors?|ited)\b|\.)/ && !hash.has_key?(:editor)
          hash[:editor] = hash.delete(:author)
          hash = normalize_editor(hash)
        else
          hash[:'more-authors'] = true if strip_et_al(authors)
          authors.gsub!(/^[^[:alnum:]]+|[^[:alnum:]]+$/, '')
          hash[:author] = normalize_names(authors)
        end

        hash
      end

      def normalize_editor(hash)
        editors, *dangling = hash[:editor]

        unless dangling.empty?
          case
          when !hash.has_key?(:author)
            hash[:author] = editors
            hash[:editor] = dangling
            hash = normalize_author(hash)
            return normalize_editor(hash)
          when dangling[0] =~ /(\d+)/
            hash[:edition] = $1.to_i
          else
            unmatched(:editor, hash, dangling)
          end
        end

        hash[:'more-editors'] = true if strip_et_al(editors)

        editors.gsub!(/^\W+|\W+$/, '')
        editors.gsub!(/^in:?\s+/i, '')
        editors.gsub!(/\W*\b[Ee]d(s|itors?|ited)?\b\W*/, '')
        editors.gsub!(/\W*\b([Hh]rsg|gg?|Herausgeber)\b\W*/, '')
        editors.gsub!(/\b[Hh]erausgegeben von\b/, '')
        editors.gsub!(/\bby\b/i, '')

        is_trans = !!editors.gsub!(/[^[:alpha:]]*trans(lated)?[^[:alpha:]]*/i, '')

        hash[:editor] = normalize_names(editors)
        hash[:translator] = hash.delete :editor if is_trans

        hash
      end

      def strip_et_al(names)
        !!names.sub!(/(\bet\s+(al|coll)\b|\bu\.\s*a\.|(\band|\&)\s+others).*$/, '')
      end

      def normalize_translator(hash)
        translators = hash[:translator]

        translators.gsub!(/\b([Ii]n (d|ein)er )?[Üü]ber(s\.|setzt|setzung|tragen|tragung) v(\.|on\b)/, '')
        translators.gsub!(/^\W+|\W+$/, '')
        translators.gsub!(/[^[:alpha:]]*\btrans(l(ated)?)?\b[^[:alpha:]]*/i, '')
        translators.gsub!(/\bby\b/i, '')
        translators.gsub!(/\btrad\./i, '')

        hash[:translator] = normalize_names(translators)
        hash
      end

      def normalize_director(hash)
        directors = hash[:director]

        directors.gsub!(/^\W+|\W+$/, '')
        directors.gsub!(/[^[:alpha:]]*direct(or|ed)?\b:w
                        [^[:alpha:]]*/i, '')
        directors.gsub!(/\bby\b/i, '')

        hash[:director] = normalize_names(directors)
        hash
      end

      def normalize_producer(hash)
        producers = hash[:producer]

        producers.gsub!(/^\W+|\W+$/, '')
        producers.gsub!(/[^[:alpha:]]*produc(er|ed)?[^[:alpha:]]*/i, '')
        producers.gsub!(/\bby\b/i, '')

        hash[:director] = normalize_names(producers)
        hash
      end

      def normalize_names(names)
        names.gsub!(/\s*(\.\.\.|…)\s*/, '')
        names.gsub!(/;|:/, ',')

        # Add surname/initial punctuation separator for Vancouver-style names
        # E.g. Rang HP, Dale MM, Ritter JM, Moore PK
        if names.match(/^(\p{Lu}[^\s,.]+)\s+([\p{Lu}][\p{Lu}\-]{0,3})(,|[.]?$)/)
          names.gsub!(/\b(\p{Lu}[^\s,.]+)\s+([\p{Lu}][\p{Lu}\-]{0,3})(,|[.]?$)/, '\1, \2\3')
        end

        Namae.parse!(names).map { |name|
          name.normalize_initials
          name.sort_order

        }.join(' and ')

      rescue => e
        warn e.message
        names
      end

      Namae.options[:prefer_comma_as_separator] = true

      def normalize_title(hash)
        title, source = hash[:title]

        unless source.nil?
          hash[:source] = source
          normalize(:source, hash)
        end

        extract_edition(title, hash)

        title.gsub!(/^\s+|[\.,:;\s]+$/, '')
        title.gsub!(/^["'”’´‘“`](.+)["'”’´‘“`]$/, '\1')

        hash[:title] = title

        hash
      end

      def extract_edition(token, hash)
        edition = [hash[:edition]].flatten.compact

        if token.gsub!(/[^[:alnum:]]*(\d+)(?:st|nd|rd|th)?\s*(?:Aufl(?:age|\.)|ed(?:ition|\.)?)[^[:alnum:]]*/i, '')
          edition << $1
        end

        if token.gsub!(/(?:\band)?[^[:alnum:]]*([Ee]xpanded)[^[:alnum:]]*$/, '')
          edition << $1
        end

        if token.gsub!(/(?:\band)?[^[:alnum:]]*([Ii]llustrated)[^[:alnum:]]*$/, '')
          edition << $1
        end

        if token.gsub!(/(?:\band)?[^[:alnum:]]*([Rr]evised)[^[:alnum:]]*$/, '')
          edition << $1
        end

        if token.gsub!(/(?:\band)?[^[:alnum:]]*([Rr]eprint)[^[:alnum:]]*$/, '')
          edition << $1
        end

        hash[:edition] = edition.join(', ') unless edition.empty?
      end

      def normalize_booktitle(hash)
        booktitle, *dangling = hash[:booktitle]
        unmatched(:booktitle, hash, dangling) unless dangling.empty?

        booktitle.gsub!(/^in:\s+/i, '')
        booktitle.gsub!(/^In\s+/i, '')

        extract_edition(booktitle, hash)

        booktitle.gsub!(/^\s+|[\.,:;\s]+$/, '')
        hash[:booktitle] = booktitle

        hash
      end

      def normalize_journal(hash)
        journal, *dangling = hash[:journal]
        unmatched(:journal, hash, dangling) unless dangling.empty?

        journal.gsub!(/^[\s]+|[\.,:;\s]+$/, '')
        hash[:journal] = journal

        hash
      end

      def normalize_source(hash)
        source, *dangling = hash[:source]
        unmatched(:source, hash, dangling) unless dangling.empty?

        case source
        when /dissertation abstracts/i
          source.gsub!(/\s*section \w: ([[:alnum:]\s]+).*$/i, '')
          hash[:category] = $1 unless $1.nil?
          hash[:type] = :thesis
        end

        hash[:source] = source
        hash
      end

      def normalize_date(hash)
        date = Array(hash[:date]).join(' ')

        unless (month = MONTH[date]).nil?
          month = '%02d' % month
        end

        if date =~ /(\d{4})/
          year = $1

          if month && date =~ /\b(\d{1,2})\b/
            day = '%02d' % $1.to_i
          end

          hash[:date] = [year, month, day].compact.join('-')
        end

        hash
      end

      def normalize_volume(hash)
        volume, *dangling = hash[:volume]
        unmatched(:volume, hash, dangling) unless dangling.empty?

        if !hash.has_key?(:pages) && volume =~ /\D*(\d+):(\d+(?:[—–-]+)\d+)/
          hash[:volume], hash[:pages] = $1.to_i, $2
          hash = normalize_pages(hash)
        else
          case volume
          when /\D*(\d+)\D+(\d+[\s\/&—–-]+\d+)/
            hash[:volume], hash[:number] = $1.to_i, $2
          when /(\d+)?\D+no\.\s*(\d+\D+\d+)/
            hash[:volume] = $1.to_i unless $1.nil?
            hash[:number] = $2
          when /(\d+)?\D+no\.\s*(\d+)/
            hash[:volume] = $1.to_i unless $1.nil?
            hash[:number] = $2.to_i
          when /\D*(\d+)\D+(\d+)/
            hash[:volume], hash[:number] = $1.to_i, $2.to_i
          when /(\d+)/
            hash[:volume] = $1.to_i
          end
        end

        hash
      end

      def normalize_publisher(hash)
        normalize :publisher, hash

        case hash[:publisher]
        when /^producers?$/i
          hash[:publisher] = hash[:producer]

        when /^authors?$/i
          hash[:publisher] = hash[:author]

        when /^editor?$/i
          hash[:publisher] = hash[:editor]

        end

        hash
      end

      def normalize_pages(hash)
        pages, *dangling = hash[:pages]
        unmatched(:pages, hash, dangling) unless dangling.empty?

        # "volume.issue(year):pp"
        case pages
        when /(\d+) (?: \.(\d+))? (?: \( (\d{4}) \))? : (\d.*)/x
          hash[:volume] = $1.to_i
          hash[:number] = $2.to_i unless $2.nil?
          hash[:year] = $3.to_i unless $3.nil?
          hash[:pages] = $4
        end

        case hash[:pages]
        when /(\d+)\D+(\d+)/
          hash[:pages] = [$1,$2].join('–') # en-dash
        when  /(\d+)/
          hash[:pages] = $1
        end

        hash
      end

      def normalize_location(hash)
        location, *dangling = hash[:location]
        unmatched(:pages, hash, dangling) unless dangling.empty?

        location.gsub!(/^[^[:alnum:]]+|[^[:alnum:]]+$/, '')

        if !hash.has_key?(:publisher) && location =~ /:/
          location, publisher = location.split(/\s*:\s*/)
          hash[:publisher] = publisher
        end

        hash[:location] = location
        hash
      end

      def normalize_isbn(hash)
        isbn, *dangling = hash[:isbn]
        unmatched(:isbn, hash, dangling) unless dangling.empty?

        isbn = isbn[/[\d-]+/]
        hash[:isbn] = isbn

        hash
      end

      def normalize_url(hash)
        url, *dangling = hash[:url]
        unmatched(:url, hash, dangling) unless dangling.empty?

        hash[:url] = url[/([a-z]+:\/\/)?\w+\.\w+[\w\.\/%-]+/i] || url
        hash
      end

      def normalize_medium(hash)
        medium, *dangling = hash[:medium]
        unmatched(:medium, hash, dangling) unless dangling.empty?

        hash[:medium] = medium.split(/\W+/).reject(&:empty?).join('-')
        hash
      end

      private

      def unmatched(label, hash, tokens)
        hash["unmatched-#{label}"] = tokens.join(' ')
      end

    end

  end
end
