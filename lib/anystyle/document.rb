module AnyStyle
  class Document < Wapiti::Sequence

    alias_method :lines, :tokens

    class << self
      def parse(string, delimiter: /\n/, tagged: false)
        new(string.split(delimiter).map { |line|
          label, line = line.split(/\s*:/, 2) if tagged
          Wapiti::Token.new line, label: label.to_s
        })
      end

      def open(path)
        raise ArgumentError,
          "cannot open document from tainted path: '#{path}'" if path.tainted?
        parse File.read(path, encoding: 'utf-8')
      end
    end

    def pages
      @pages ||= Page.parse(lines)
    end

    def to_a(encode: true, **options)
      super encode: encode, **options
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
    end
  end
end
