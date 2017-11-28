module Anystyle
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

    # TODO sequence features should be called just once
    def sequence?
      false
    end

    def elicit(token, alpha, offset, sequence)
      raise NotImplementedError
    end
  end
end
