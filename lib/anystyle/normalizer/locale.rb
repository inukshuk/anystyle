module AnyStyle
  maybe_require 'language_detector'

  class Normalizer
    class Locale < Normalizer
      def initialize
        @ld = LanguageDetector.new if defined?(LanguageDetector)
      end

      def normalize(item)
        return item if @ld.nil? || item.key?(:language)

        sample = item.values_at(
          :title,
          :'container-title',
#          :'collection-title',
          :journal,
          :location,
          :publisher
#          :note
        ).flatten.compact.join(' ')

        return item if sample.empty?

        item[:language] = @ld.detect(sample)
        item
      end
    end
  end
end
