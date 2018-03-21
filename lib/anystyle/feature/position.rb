module AnyStyle
  class Feature
    class Position < Feature
      attr_reader :precision, :idx, :seq

      def initialize(precision: 100, idx: :idx, seq: :seq)
        @precision, @idx, @seq = precision, idx, seq
      end

      def observe(token, **opts)
        ((opts[idx].to_f / opts[seq].size) * precision).round
      end
    end
  end
end
