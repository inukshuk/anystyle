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

  module PdfUtils
    module_function

    def pdf_to_text(path)
      %x{pdftotext -layout -eol unix -q "#{path}" -}
    end

    def pdf_info(path)
      Hash[%x{pdfinfo -isodates "#{path}"}.split("\n").map { |ln|
        ln.split(/:\s+/, 2)
      }]
    end

    def pdf_meta(path)
      %x{pdfinfo -meta -isodates "#{path}"}
    end
  end

  extend Utils
end
