module AnyStyle
  class Finder < ParserCore
    @formats = [:wapiti]

    @defaults = {
      #model: File.join(SUPPORT, 'finder.mod'),
      pattern: File.join(SUPPORT, 'finder.txt'),
      compact: true,
      threads: 4,
      separator: /^::: ANYSTYLE SEQUENCE BREAK :::$/,
      delimiter: /\n/,
      format: :wapiti
    }

    def initialize(options = {})
      super(options)
    end

    def expand(dataset)
      dataset.each do |doc|
        doc.each_with_index do |(line, page, pn), ln|
          line.observations = features.map { |f|
            f.observe line.value, page: page, doc: doc, pn: pn, ln: ln
          }
        end
      end
    end
  end
end
