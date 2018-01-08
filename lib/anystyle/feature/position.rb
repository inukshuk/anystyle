module AnyStyle
  class Feature
    class Position < Feature
      attr_reader :precision

      def initialize(precision: 100)
        @precision = precision
      end

      def observe(token, alpha, offset, sequence)
        ((offset.to_f / sequence.size) * precision).round
      end
    end
  end
end
