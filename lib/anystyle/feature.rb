module AnyStyle
  class Feature
    include StringUtils

    def observe(token, alpha, offset, sequence)
      raise NotImplementedError
    end

    def next(offset, sequence)
      sequence[offset + 1]
    end

    def prev(offset, sequence)
      offset == 0 ? nil : sequence[offset - 1]
    end
  end
end
