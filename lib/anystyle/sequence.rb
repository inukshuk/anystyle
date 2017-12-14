module AnyStyle
  class Sequence
    extend Forwardable
    include Comparable
    include Enumerable

    attr_reader :tokens
    def_delegators :tokens, :[], :size

    def initialize(tokens: [])
      @tokens = tokens
    end

    def <=>(other)
    end

    def tagged?
      all?(&:label?)
    end

    def each
      if block_given?
        tokens.each(&Proc.new)
        self
      else
        to_enum
      end
    end

    alias_method :each_token, :each

    def each_segment(delimiter: ' ')
      if block_given?
        segment
        current

        each do |token|
          value, label = token.to_a(tag: true)

          if current != label
            unless segment.nil? || segment.empty?
              yield segment.join(delimiter), current
            end

            segment, current = [], label
          else
            segment << value
          end
        end

        self
      else
        to_enum :each_segment
      end
    end

    def to_a(**options)
      map { |tk| tk.to_a(**options) }
    end

    def to_s(separator: ' ', **options)
      map { |tk| tk.to_s(**options) }.join(separator)
    end

    def to_h(**options)
      Hash[*each_segment(**options).to_a]
    end

    def to_xml(xml = Builder::XmlMarkup.new)
      xml.sequence do |sq|
        each_segment do |label, segment|
          sq.tag! label, segment
        end
      end
    end
  end
end
