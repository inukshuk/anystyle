module Anystyle
  class Feature
    @available = {}

    class << self
      def inherited(feature)
        @available[feature.feature_name] = feature
      end

      def feature_name
        @feature_name || name.downcase.intern
      end
    end

    attr_reader :dictionary

    def initialize(dictionary: nil)
      @dictionary = dictionary
    end

    def name
      self.class.feature_name
    end

    # TODO sequence features should be called just once
    def sequence?
      false
    end

    def elicit
      raise NotImplementedError
    end
  end
end
