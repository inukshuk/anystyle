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

    def nnum(string, symbol = '#')
      string.unicode_normalize.gsub(/\d/, symbol)
    end

    def page_break?(string)
      string =~ /\f/
    end

    def display_width(string)
      display_chars(string).length
    end

    def display_chars(string)
      string
        .gsub(/\t/, '    ')
        .gsub(/\p{Mn}|\p{Me}|\p{Cc}/, '')
        .gsub(/\p{Zs}/, ' ')
        .rstrip
    end

    def count(string, pattern)
      string.to_enum(:scan, pattern).inject(0) { |c| c + 1 }
    end

    def indent(token)
      display_chars(token)[/^(\s*)/].length
    end

    def strip_html(string)
      string
        .gsub(/<\/?(italic|i|strong|b|span|div)(\s+style="[^"]+")?>/i, '')
    end
  end

  module PDFUtils
    module_function

    def pdf_to_text(path, **opts)
      text = %x{pdftotext #{pdf_opts(path, **opts).join(' ')} "#{path}" -}
      raise "pdftotext failed with error code #{$?.exitstatus}" unless $?.success?
      text.force_encoding(opts[:encoding] || 'UTF-8')
    end

    def pdf_info(path)
      Hash[%x{pdfinfo -isodates "#{path}"}.split("\n").map { |ln|
        ln.split(/:\s+/, 2)
      }]
    end

    def pdf_meta(path)
      %x{pdfinfo -meta -isodates "#{path}"}
    end

    def pdf_page_size(path)
      pdf_info(path)['Page size'].scan(/\d+/)[0, 2].map(&:to_i)
    end

    private

    def pdf_opts(path, layout: true, encoding: 'UTF-8', **opts)
      [
        layout ? '-layout' : '',
        opts[:crop] ? pdf_crop(path, opts[:crop]) : '',
        '-eol unix',
        "-enc #{encoding}",
        '-q'
      ]
    end

    def pdf_crop(path, args)
      (x, y, w, h) = case args.length
        when 1
          [args[0], args[0], -args[0], -args[0]]
        when 2
          [args[0], args[1], -args[0], -args[1]]
        when 4
          args
        else
          raise "invalid crop option: #{args}"
        end

      if w < 0 || h < 0
        (width, height) = pdf_page_size(path)
        w = width - x + w if w < 0
        h = height - y + h if h < 0
      end

      "-x #{x} -y #{y} -W #{w} -H #{h}"
    end
  end

  extend Utils
end
