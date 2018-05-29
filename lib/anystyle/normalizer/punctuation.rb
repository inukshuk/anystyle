module AnyStyle
  class Normalizer
    class Punctuation < Normalizer
      @keys = [
        :date,
        :edition,
        :title,
        :'container-title',
        :'collection-title',
        :publisher,
        :location
      ]

      def normalize(item)
        each_value(item) do |_, value|
          value.gsub!(/[\)\]\.,:;\p{Pd}\p{Z}\p{C}]+$/, '')
          value.gsub!(/^[\(\[]/, '')
        end
      end
    end
  end
end
