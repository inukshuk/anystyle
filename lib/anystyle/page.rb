module AnyStyle
  class Page
    extend StringUtils

    class << self
      def parse(lines, document)
        pages, current, width = [], [], 0

        lines.each do |line|
          chars = display_chars(line.value)
          document.line_counts[chars] += 1
          document.nnum_counts[nnum(chars)] += 1

          if page_break?(line.value)
            unless current.empty?
              pages << new(current, width: width)
            end

            current = [line]
            width = chars.length
          else
            current << line
            width = [width, chars.length].max
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
      "#<AnyStyle::Page size={#{size}} width={#{width}}>"
    end
  end
end
