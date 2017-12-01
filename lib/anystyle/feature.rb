module AnyStyle
  class Feature
    @available = {}

    class << self
      attr_reader :available

      def inherited(feature)
        available[feature.key] = feature
      end

      def key
        @key || name.downcase.intern
      end
    end

    include UnicodeUtils

    def name
      self.class.key
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
