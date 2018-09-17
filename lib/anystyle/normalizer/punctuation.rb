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
          value.gsub!(/\s*[\)\]\.,:;\p{Pd}\p{Z}\p{C}。、》〉]+$/, '')
          value.gsub!(/[,:;》〉]+$/, '')
          value.gsub!(/^[\(\[《〈]/, '')
          value.gsub!(/<\/?(italic|bold)>/, '')
        end
      end
    end
  end
end
