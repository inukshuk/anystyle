module AnyStyle
  class Feature
    class Position < Feature
      attr_reader :idx, :seq

      def initialize(idx: :idx, seq: :seq, **opts)
        super(opts)
        @idx, @seq = idx, seq
      end

      def observe(token, **opts)
        i = opts[idx]
        n = opts[seq].size

        case
        when i == 0 && i == n - 1
          :only
        when i == 0
          :first
        when i == n - 1
          :last
        else
          ratio i, n
        end
      end
    end
  end
end
