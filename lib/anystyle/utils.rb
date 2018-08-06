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
      display_chars(string).rstrip.length
    end

    def display_chars(string)
      string
        .gsub(/\p{Mn}|\p{Me}|\p{Cc}/, '')
        .gsub(/\p{Zs}/, ' ')
    end

    def count(string, pattern)
      string.to_enum(:scan, pattern).inject(0) { |c| c + 1 }
    end

    def indent(token)
      display_chars(token).rstrip[/^(\s*)/].length
    end

    def strip_html(string)
      string
        .gsub(/<\/?(italic|i|strong|b|span|div)(\s+style="[^"]+")?>/i, '')
    end
  end

  module PdfUtils
    module_function

    def pdf_to_text(path, layout: true)
      text = %x{pdftotext #{layout ? ' -layout' : ''} -eol unix -enc utf8 -q "#{path}" -}
      raise "pdftotext failed with error code #{$?.exitstatus}" unless $?.success?
      text.force_encoding('UTF-8')
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
