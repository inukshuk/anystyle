module AnyStyle
  class Normalizer
    @available = {}

    class << self
      attr_reader :available

      def inherited(normalizer)
        available[normalizer.key] = normalizer
      end

      def key
        @key || name.downcase.intern
      end
    end

    def name
      self.class.key
    end

    def normalize
      raise NotImplementedError
    end
  end
end
