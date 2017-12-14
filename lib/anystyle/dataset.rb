module AnyStyle
  class DataSet
    include Comparable
    include Enumerable

    attr_reader :sequences

    def initialize
      @sequences = []
    end

    def each(*args)
      sequences.each(*args)
    end

    def <=>(other)
    end

    def to_a
    end

    def to_h
    end

    def to_xml
    end
  end
end
