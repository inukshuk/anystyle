module AnyStyle
  class Normalizer
    @keys = []

    class << self
      attr_reader :keys
    end

    attr_reader :keys
    attr_accessor :skip

    def initialize(keys: self.class.keys)
      @keys = keys
      @skip = false
    end

    def name
      self.class.name
    end

    def normalize(item, **opts)
      raise NotImplementedError
    end

    def append(item, key, value)
      if item.key?(key)
        item[key] << value
      else
        item[key] = [value]
      end
    end

    def each_value(item, keys = keys_for(item))
      keys.each do |key|
        item[key].each do |value|
          yield key, value
        end if item.key?(key)
      end
      item
    end

    def map_values(item, keys = keys_for(item))
      keys.each do |key|
        if item.key?(key)
          item[key] = item[key].map { |value|
            yield key, value
          }.flatten.reject { |v| v.nil? || v.empty? }
        end
      end
      item
    end

    def keys_for(item)
      if self.class.keys.empty?
        item.keys
      else
        self.class.keys
      end
    end

    def skip?
      @skip
    end
  end
end
