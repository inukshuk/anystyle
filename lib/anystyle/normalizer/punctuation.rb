module AnyStyle
  class Normalizer
    class Punctuation < Normalizer
      @keys = [
        :'container-title',
        :'collection-title',
        :date,
        :edition,
        :journal,
        :location,
        :publisher,
        :title
      ]

      def normalize(item, **opts)
        each_value(item) do |_, value|
          value.gsub!(/[\)\]\.,:;\p{Pd}\p{Z}\p{C}]+$/, '')
          value.gsub!(/^[\(\[]/, '')
        end
      end
    end
  end
end
