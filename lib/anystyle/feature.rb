module AnyStyle
  class Feature
    include StringUtils

    def observe(token, **opts)
      raise NotImplementedError
    end

    def next(offset, seq)
      sequence[offset + 1]
    end

    def prev(offset, seq)
      offset == 0 ? nil : seq[offset - 1]
    end
  end
end
