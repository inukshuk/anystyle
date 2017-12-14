module AnyStyle
  class Token
    include Comparable

    attr_accessor :value, :label, :features

    def initialize(value: '', label: '', features: [])
      @value, @label, @features = value, label, features
    end

    def features?
      !(features.nil? || features.empty?)
    end

    def label?
      !(label.nil? || label.empty?)
    end

    def <=>(other)
      value.to_s <=> other.to_s
    end

    def to_s(separator: ' ', **options)
      to_a(**options).join(separator)
    end

    def to_a(expand: false, tag: false)
      a = [value]
      a.concat features if (exapand and features?)
      a << label if (tag and label?)
      a
    end
  end
end
