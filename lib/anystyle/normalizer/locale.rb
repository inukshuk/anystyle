module AnyStyle
  maybe_require 'cld'
  maybe_require 'unicode/scripts'

  class Normalizer
    class Locale < Normalizer
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

        item[:language] ||= language[:code] unless language.nil?
        item[:scripts] ||= scripts unless scripts.nil?
        item
      end
    end

    def detect_language(string)
      ::CLD.detect_language(string) if defined?(::CLD)
    end

    def detect_scripts(string)
      ::Unicode::Scripts.scripts(string) if defined?(::Unicode::Scripts)
    end
  end
end
