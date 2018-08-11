module AnyStyle
  maybe_require 'language_detector'
  maybe_require 'unicode/scripts'

  class Normalizer
    class Locale < Normalizer
      def initialize
        @ld = LanguageDetector.new if defined?(LanguageDetector)
      end

      def normalize(item, **opts)
        sample = item.values_at(
          :title,
          :'container-title',
          :'collection-title',
          :location,
          :journal,
          :publisher,
          :note
        ).flatten.compact.join(' ')

        return item if sample.empty?

        language = detect_language(sample)
        scripts = detect_scripts(sample)

        item[:language] ||= language unless language.nil?
        item[:scripts] ||= scripts unless scripts.nil?
        item
      end
    end

    def detect_language(string)
      @ld.detect(string) unless @ld.nil?
    end

    def detect_scripts(string)
      ::Unicode::Scripts.scripts(string) if defined?(::Unicode::Scripts)
    end
  end
end
