module AnyStyle
  class Feature
    class Position < Feature
      attr_reader :precision, :idx, :seq

      def initialize(precision: 100, idx: :idx, seq: :seq)
        @precision, @idx, @seq = precision, idx, seq
      end

      def observe(token, **opts)
        i = opts[idx]
        n = opts[seq].size

        case
        when i == 0 && i == n - 1
          :only
        when i == 0
          :first
        when i = n - 1
          :last
        else
          ((i.to_f / n) * precision).round
        end
      end
    end
  end
end
