module AnyStyle
  maybe_require 'cld3'
  maybe_require 'unicode/scripts'

  class Normalizer
    class Locale < Normalizer
      def initialize
        if defined?(::CLD3)
          @ld = ::CLD3::NNetLanguageIdentifier.new(0, 1000)
        end
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

        item[:language] ||= language.to_s unless language.nil?
        item[:scripts] ||= scripts unless scripts.nil?
        item
      end
    end

    def detect_language(string)
      if instance_variable_defined?('@ld') && string.length > 8
        @ld.find_language(string).language
      end
    end

    def detect_scripts(string)
      ::Unicode::Scripts.scripts(string) if defined?(::Unicode::Scripts)
    end
  end
end
