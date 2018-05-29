module AnyStyle
  class Normalizer
    class Brackets < Normalizer
      @keys = [:'citation-number', :note]

      def normalize(item)
        each_value(item) do |_, value|
          value.gsub!(/^[\(\[\{]|[\]\)\}]$/, '')
        end
      end
    end
  end
end
