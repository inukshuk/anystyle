module AnyStyle
  class Normalizer
    class Punctuation < Normalizer
      @keys = [
        :date, :title, :booktitle, :publisher, :location, :journal
      ]

      def normalize(item)
        each_value(item) do |_, value|
          unless value =~ /[!?]$/
            value.gsub!(/\p{Punct}+$/, '')
          end
        end
      end
    end
  end
end
