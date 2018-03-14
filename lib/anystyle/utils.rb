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
    module_function

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

    def page_break?(string)
      string =~ /\f/
    end

    def display_width(string)
      string.gsub(/\p{Mn}|\p{Me}|\p{C}/, '').length
    end
  end

  extend Utils
end
