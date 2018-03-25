module AnyStyle
  class Feature
    include StringUtils

    attr_reader :precision

    def initialize(precision: 10, **opts)
      @precision = precision
    end

    def observe(token, **opts)
      raise NotImplementedError
    end

    def next(idx, seq)
      sequence[idx + 1]
    end

    def prev(idx, seq)
      idx == 0 ? nil : seq[idx - 1]
    end

    def ratio(x, y)
      (y > 0) ? ((x.to_f / y) * precision).round : 0
    end
  end
end
