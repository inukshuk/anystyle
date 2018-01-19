module AnyStyle
  maybe_require 'language_detector'

  class Normalizer
    class Locale < Normalizer
      def initialize
        @ld = LanguageDetector.new if defined?(LanguageDetector)
      end

      def normalize(item)
        return if @ld.nil? || item.key?(:language)

        sample = item.values_at(
          :title, :booktitle, :journal, :location, :publisher
        ).flatten.join(' ')

        return if sample.empty?

        item[:language] = @ld.detect(sample)
      end
    end
  end
end
