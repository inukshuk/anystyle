module AnyStyle
  class Sequence
    include Comparable
    include Enumerable

    attr_reader :tokens

    def initialize()
      @tokens = []
    end

    def each(*args)
      tokens.each(*args)
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
