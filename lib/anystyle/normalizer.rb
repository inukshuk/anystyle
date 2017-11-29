module AnyStyle
  class Normalizer
    @available = {}

    class << self
      attr_reader :available

      def inherited(normalizer)
        available[normalizer.name] = normalizer
      end
    end

    def name
      self.class.name.downcase.intern
    end

    def normalize
      raise NotImplementedError
    end
  end
end
