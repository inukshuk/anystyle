module AnyStyle
  class DataSet
    extend Forwardable
    include Comparable
    include Enumerable

    attr_reader :sequences
    def_delegators :sequences, :[], :size, :sample

    def initialize(sequences: [])
      @sequences = sequences
    end

    def each
      if block_given?
        sequences.each(&Proc.new)
        self
      else
        to_enum
      end
    end

    def <=>(other)
    end

    def to_s(separator: '\n', **options)
      map { |sq| sq.to_s(**options) }.join(separator)
    end

    def to_a(**options)
      map { |sq| sq.to_a(**options) }
    end

    def to_xml(**options)
      xml = Builder::XmlMarkup.new(**options)
      xml.instruct!
      xml.dataset do |ds|
        each do |seq|
          seq.to_xml ds
        end
      end
    end
  end
end
