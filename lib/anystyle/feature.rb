module AnyStyle
  class Feature
    @available = {}

    class << self
      attr_reader :available

      def inherited(feature)
        available[feature.name] = feature
      end
    end

    def name
      self.class.name.downcase.intern
    end

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
