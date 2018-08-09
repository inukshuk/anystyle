module AnyStyle
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
      "#<AnyStyle::Page size={#{size}} width={#{width}}>"
    end
  end
end
