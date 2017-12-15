module AnyStyle
  class Token
    include Comparable

    attr_accessor :value, :label, :observations

    def initialize(value: '', label: '', observations: [])
      @value, @label, @observations = value, label, observations
    end

    def observations?
      !(observations.nil? || observations.empty?)
    end

    def label?
      !(label.nil? || label.empty?)
    end

    def <=>(other)
      value.to_s <=> other.to_s
    end

    def to_s(delimiter: ' ', **options)
      to_a(**options).join(delimiter)
    end

    def to_a(expand: false, tag: false)
      a = [value]

      if expand
        raise Error,
          'cannot expand token: missing observations' unless observations?
        a.concat observations
      end

      if tag
        raise Error,
          'cannot tag token: missing label' unless label?
        a << label
      end

      a
    end
  end
end
