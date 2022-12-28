module AnyStyle
  class Finder < ParserCore
    @formats = [:hash, :references, :wapiti]

    @defaults = {
      model: File.join(SUPPORT, 'finder.mod'),
      pattern: File.join(SUPPORT, 'finder.txt'),
      compact: true,
      threads: 4,
      format: :references,
      training_data: Dir[File.join(RES, 'finder', '*.ttx')],
      layout: true,
      pdftotext: 'pdftotext',
      pdfinfo: 'pdfinfo'
    }

    def initialize(options = {})
      super(options)

      @features = [
        Feature::Line.new,
        Feature::Category.new(strip: true),
        Feature::Words.new(dictionary: options[:dictionary] || Dictionary.instance),
        Feature::Indent.new,
        Feature::Ref.new,
        Feature::Position.new(seq: :page, idx: :ln),
        Feature::Position.new(seq: :pages, idx: :pn)
      ]
    end

    def expand(dataset)
      dataset.each do |doc|
        doc.each.with_index do |(line, ln, page, pn), idx|
          line.observations = features.map.with_index { |f, fn|
            f.observe line.value,
              page: page,
              pages: doc.pages,
              seq: doc,
              pn: pn,
              ln: ln,
              fn: fn,
              idx: idx
          }.flatten
        end
      end
    end

    def find(input, format: options[:format], **opts)
      case format.to_sym
      when :references, :ref
        format_references(label(input, **opts), **opts)
      when :hash
        format_hash(label(input, **opts), **opts)
      when :wapiti
        label(input, **opts)
      else
        raise ArgumentError, "unknown format '#{format}'"
      end
    end

    def format_hash(dataset, **opts)
      dataset.map { |doc| doc.to_h(**opts) }
    end

    def format_references(dataset, **opts)
      dataset.map { |doc| doc.references(**opts) }
    end

    def label(input, layout: true, crop: false, **opts)
      dataset = prepare(input, layout: layout, crop: crop, **opts)
      output = model.label(dataset, **opts)
      Wapiti::Dataset.new(dataset.map.with_index { |doc, idx|
        doc.label(output[idx])
      })
    end

    def prepare(input,
                layout: options[:layout],
                crop: false,
                pdftotext: options[:pdftotext],
                pdfinfo: options[:pdfinfo],
                **opts)
      doc_opts = { layout: layout, crop: crop, pdftotext: pdftotext, pdfinfo: pdfinfo, **opts }
      case input
      when String
        super(Document.open(input, **doc_opts), **opts)
      when Array
        super(Wapiti::Dataset.new(input.map { |f| Document.open(f, **doc_opts) }), **opts)
      else
        super(input, **opts)
      end
    end

    def save_each(dataset, dir: '.', tagged: false, **opts)
      dataset.each.with_index do |doc, idx|
        name = doc.path.nil? ? idx : File.basename(doc.path, File.extname(doc.path))
        file = "#{name}.#{tagged ? 'ttx' : 'txt'}"
        File.write(File.join(dir, file), doc.to_s(tagged: tagged, **opts))
      end
    end

  end
end
