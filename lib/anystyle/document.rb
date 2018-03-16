module AnyStyle
  class Document < Wapiti::Sequence
    class << self
      include PdfUtils

      def parse(string, delimiter: /\n/, tagged: false)
        current_label = nil
        new(string.split(delimiter).map { |line|
          label, line = line.split(/\s*:/, 2) if tagged
          current_label = label || current_label
          Wapiti::Token.new line, label: current_label.to_s
        })
      end

      def open(path, format: File.extname(path), tagged: false, **options)
        raise ArgumentError,
          "cannot open tainted path: '#{path}'" if path.tainted?
        raise ArgumentError,
          "document not found: '#{path}'" unless File.exist?(path)

        path = File.absolute_path(path)

        case format.downcase
        when '.pdf'
          meta = pdf_meta path if options[:parse_meta]
          info = pdf_info path if options[:parse_info]
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

    alias_method :lines, :tokens
    attr_accessor :meta, :info, :path, :pages

    def pages
      @pages ||= Page.parse(lines)
    end

    def each
      if block_given?
        pages.each.with_index do |page, idx|
          page.lines.each do |line|
            yield line, page, idx
          end
        end
        self
      else
        to_enum
      end
    end

    def to_a(encode: true, **options)
      super encode: encode, **options
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

          pages
        end
      end

      attr_accessor :lines, :width

      def initialize(lines = [], width: 0)
        @lines = lines
        @width = width
      end

      def inspect
        "#<AnyStyle::Document::Page lines={#{lines.length}} width={#{width}}>"
      end
    end
  end
end
