module AnyStyle
  module Utils
    def maybe_require(mod)
      require mod
      yield if block_given?
    rescue LoadError
      # ignore
    end
  end

  module StringUtils
    def scrub(string, blacklist: /[\p{^Alnum}\p{Lm}]/)
      string.scrub.gsub(blacklist, '')
    end

    def transliterate(string, form: :nfkd)
      string
        .unicode_normalize(form)
        .gsub(/\p{Mark}/, '')
    end

    def canonize(string)
      scrub(transliterate(string)).downcase
    end

    XML_ENTITIES = Hash[*%w{
      &amp; & &lt; < &gt; > &apos; ' &quot; "
    }].freeze

    def decode_xml_text(string)
      string.gsub(/&(amp|gt|lt);/) { |entity| XML_ENTITIES[entity] }
    end

    def encode_xml_text(string)
      string.encode string.encoding, xml: :text
    end
  end

  extend Utils
end
