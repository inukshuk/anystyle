module AnyStyle
  class Document < Wapiti::Sequence

    REFSECT = /reference|works|biblio|cite|secondary sources/i

    class << self
      include PDFUtils

      def parse(string, delimiter: /\r?\n/, tagged: false)
        current_label = ''
        new(string.split(delimiter).map { |line|
          if tagged
            label, line = line.split(/\s*\| /, 2)
            current_label = label unless label.empty?
          end
          Wapiti::Token.new line, label: current_label.to_s
        })
      end

      def open(path, format: File.extname(path), tagged: false, **opts)
        raise ArgumentError,
          "cannot open tainted path: '#{path}'" if path.tainted?
        raise ArgumentError,
          "document not found: '#{path}'" unless File.exist?(path)

        path = File.absolute_path(path)

        case format.downcase
        when '.pdf'
          meta = pdf_meta path if opts[:parse_meta]
          info = pdf_info path if opts[:parse_info]
          input = pdf_to_text path, **opts
        when '.ttx'
          tagged = true
          input = File.read(path, encoding: 'utf-8')
        when '.txt'
          input = File.read(path, encoding: 'utf-8')
        end

        doc = parse input, tagged: tagged
        doc.path = path
        doc.meta = meta
        doc.info = info
        doc
      end
    end

    include StringUtils

    attr_accessor :meta, :info, :path, :pages, :tokens
    alias_method :lines, :tokens

    def line_counts
      @line_counts ||= Hash.new(0)
    end

    def pages
      @pages ||= Page.parse(lines, self)
    end

    def each
      if block_given?
        pages.each.with_index do |page, pn|
          page.lines.each.with_index do |line, ln|
            yield line, ln, page, pn
          end
        end
        self
      else
        to_enum
      end
    end

    def each_section(skip: ['meta'])
      if block_given?
        head = []
        body = []
        seen_content = false

        lines.each do |ln|
          case ln.label
          when 'title'
            if seen_content
              yield [head, body]
              head, body, seen_content = [ln], [], false
            else
              head << ln
            end
          when 'ref', 'text'
            body << ln
            seen_content = true
          else
            body << ln unless skip.include?(ln.label)
          end
        end
        unless head.empty?
          yield [head, body]
        end
        self
      else
        to_enum :each_section
      end
    end

    def label(other)
      doc = dup
      doc.tokens = lines.map.with_index { |line, idx|
        Wapiti::Token.new line.value,
          label: other[idx].label.to_s,
          observations: other[idx].observations.dup,
          score: other[idx].score
      }
      doc
    end

    def to_s(delimiter: "\n", encode: false, tagged: false, **opts)
      if tagged
        prev_label = nil
        lines.map { |ln|
          label = (ln.label == prev_label) ? '' : ln.label
          prev_label = ln.label
          '%.14s| %s' % ["#{label}              ", ln.value]
        }.join(delimiter)
      else
        super(delimiter: delimiter, encode: encode, tagged: tagged, expanded: false, **opts)
      end
    end

    def to_a(encode: true, **opts)
      super(encode: encode, **opts)
    end

    def to_h(**opts)
      {
        info: info,
        meta: meta,
        sections: sections(**opts),
        title: title(**opts),
        references: references(**opts)
      }
    end

    def references(normalize_blocks: false, **opts)
      if normalize_blocks
        each_section.inject([]) do |refs, (head, body)|
          rc = body.count { |tk| tk.label == 'ref' }
          unless rc == 0
            tc = body.count { |tk| tk.label == 'text' }
            is_ref_sect = !head.find { |tk| tk.value =~ REFSECT }.nil?

            # Skip sections with few ref lines!
            if is_ref_sect || rc > 10 || (rc.to_f / tc) > 0.2
              Refs.normalize! body, max_win_size: is_ref_sect ? 6 : 2
              refs.concat Refs.parse(body).to_a
            end
          end

          refs
        end
      else
        Refs.parse(lines).to_a
      end
    end

    def sections(delimiter: "\n", spacer: ' ', **opts)
      each_section.map do |(head, body)|
        {
          title: head.map { |tk|
            display_chars(tk.value).strip.unicode_normalize
          }.join(spacer),
          text: body.map { |tk|
            display_chars(tk.value).rstrip.unicode_normalize
          }.join(delimiter)
        }
      end
    end

    def title(delimiter: " ", **opts)
      lines.drop_while { |ln|
        ln.label != 'title'
      }.take_while { |ln|
        ln.label == 'title'
      }.map(&:value).join(delimiter)
    end

    def inspect
      "#<AnyStyle::Document lines={#{size}}>"
    end
  end
end
