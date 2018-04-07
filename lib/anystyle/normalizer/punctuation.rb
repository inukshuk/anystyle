module AnyStyle
  class Normalizer
    class Punctuation < Normalizer
      @keys = [
        :date,
        :title,
        :'container-title',
        :'collection-title',
        :publisher,
        :location
      ]

      def normalize(item)
        each_value(item) do |_, value|
          unless value =~ /[!?]$/
            value.gsub!(/[\p{P}\p{Z}\p{C}]+$/, '')
          end
        end
      end
    end
  end
end
