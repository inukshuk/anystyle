module Anystyle
  class Feature
    class Offset < Feature
      def elicit(_, offset:, sequence:)
        ((offset.to_f / sequence.length) * 10).round
      end
    end
  end
end
