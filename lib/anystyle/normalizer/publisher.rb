module AnyStyle
  class Normalizer
    class Publisher < Normalizer
      @keys = [:publisher]

      def normalize(item)
        replace_author(item) if item.key?(:author)
        item
      end

      def replace_author(item)
        each_value(item) do |_, value|
          value.gsub!(/^Author$/, item[:author][0])
        end
      end
    end
  end
end
