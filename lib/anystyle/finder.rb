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

      @features = [
        Feature::Position.new(idx: :pn),
        Feature::Position.new(seq: :page, idx: :ln)
      ]
    end

    def expand(dataset)
      dataset.each do |doc|
        doc.each.with_index do |(line, ln, page, pn), idx|
          line.observations = features.map { |f|
            f.observe line.value, page: page, seq: doc, pn: pn, ln: ln, idx: idx
          }
        end
      end
    end
  end
end
