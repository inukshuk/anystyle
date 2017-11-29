module AnyStyle
  class Feature
    def elicit(token, alpha, offset, sequence)
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
