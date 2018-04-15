module AnyStyle
  class Normalizer
    class Journal < Normalizer
      def normalize(item)
        if item.key?(:journal)
          item[:type] = 'article-journal'
          item[:journal].each { |journal| append item, :'container-title', journal }
          item.delete(:journal)
        end
        item
      end
    end
  end
end
