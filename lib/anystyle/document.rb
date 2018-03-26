module AnyStyle
  class Document < Wapiti::Sequence
    class << self
      include PdfUtils

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
          input = pdf_to_text path
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

    attr_accessor :meta, :info, :path, :pages, :tokens
    alias_method :lines, :tokens

    def pages
      @pages ||= Page.parse(lines)
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

    def label(other)
      doc = dup
      doc.tokens = lines.map.with_index { |line, idx|
        Wapiti::Token.new line.value,
          label: other[idx].label.to_s,
          observations: other[idx].observations.dup
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

    def references(**opts)
      bib, current, delta = [], nil, 0

      lines.each do |ln|
        case ln.label
        when 'ref'
          if current.nil?
            current, delta = ln.value.strip, 0
          else
            if join_refs?(current, ln.value, delta, ln.observations[15] == '+')
              current = join_refs(current, ln.value.strip)
            else
              bib << current
              current, delta = ln.value.strip, 0
            end
          end
        else
          delta += 1 unless current.nil?
        end
      end

      unless current.nil?
        bib << current
      end

      bib
    end

    def join_refs?(a, b, delta = 0, indent = false)
      delta <= 5 && [
        indent,
        b.length < a.length || a.length < 100,
        a !~ /[.\]]$/,
        b =~ /^\p{Ll}/
      ].count(true) > 1
    end

    def join_refs(a, b)
      if a[-1] == '-'
        if b =~ /^\p{Ll}/
          "#{a[0...-1]}#{b}"
        else
          "#{a}#{b}"
        end
      else
        "#{a} #{b}"
      end
    end

    def sections(delimiter: "\n", **opts)
      []
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


    class Page
      extend StringUtils

      class << self
        def parse(lines)
          pages, current, width = [], [], 0

          lines.each do |line|
            if page_break?(line.value)
              unless current.empty?
                pages << new(current, width: width)
              end

              current = [line]
              width = display_width(line.value)
            else
              current << line
              width = [width, display_width(line.value)].max
            end
          end

          unless current.empty?
            pages << new(current, width: width)
          end

          pages
        end
      end

      attr_accessor :lines, :width

      def initialize(lines = [], width: 0)
        @lines = lines
        @width = width
      end

      def size
        lines.size
      end

      def inspect
        "#<AnyStyle::Document::Page size={#{size}} width={#{width}}>"
      end
    end
  end
end
