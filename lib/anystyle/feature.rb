module AnyStyle
  class Feature
    @available = {}

    class << self
      def inherited(feature)
        @available[feature.feature_name] = feature
      end

      def feature_name
        @feature_name || name.downcase
      end
    end

    def name
      self.class.feature_name
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
