module AnyStyle
  class Feature
    include StringUtils

    def observe(token, **opts)
      raise NotImplementedError
    end

    def next(idx, seq)
      sequence[idx + 1]
    end

    def prev(idx, seq)
      idx == 0 ? nil : seq[idx - 1]
    end
  end
end
