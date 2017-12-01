module AnyStyle
  class Normalizer
    @available = {}
    @labels = []

    class << self
      attr_reader :available, :label

      def inherited(normalizer)
        available[normalizer.key] = normalizer
      end

      def key
        @key || name.downcase.intern
      end
    end

    attr_reader :labels

    def initialize(labels: self.class.labels)
      @labels = labels.uniq
    end

    def name
      self.class.key
    end

    def normalize(item)
      raise NotImplementedError
    end

    def append(item, label, value)
      if item.has_key?(label)
        item[label] << value
      else
        item[label] = [value]
      end
    end

    def each_value(item)
      labels_for(item).each do |label|
        item[label].each do |value|
          yield label, value
        end if item.has_key?(label)
      end
    end

    def map_values(item)
      labels_for(item).each do |label|
        item[label] = item[label].map { |value|
          yield label, value
        }.flatten.reject(&:empty?) if item.has_key?(label)
      end
    end

    def labels_for(item)
      if labels.empty?
        item.keys
      else
        labels
      end
    end
  end
end
