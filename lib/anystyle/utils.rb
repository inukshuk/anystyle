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
  end

  extend Utils
end
