module AnyStyle
  class Finder < ParserCore
    @formats = [:hash, :references, :wapiti]

    @defaults = {
      model: File.join(SUPPORT, 'finder.mod'),
      pattern: File.join(SUPPORT, 'finder.txt'),
      compact: true,
      threads: 4,
      format: :references,
      training_data: Dir[File.join(RES, 'finder', '*.ttx')].map(&:untaint)
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
          }
        end
      end
    end

    def find(input, format: options[:format], **opts)
      case format
      when :references, :ref
        format_references(label(input, **opts))
      when :hash
        format_hash(label(input, **opts))
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

    def label(input, **opts)
      dataset = prepare(input, **opts)
      output = model.label(dataset, **opts)
      Wapiti::Dataset.new(dataset.map.with_index { |doc, idx|
        doc.label(output[idx])
      })
    end

    def prepare(input, **opts)
      case input
      when String
        super(Document.open(input, **opts), **opts)
      when Array
        super(Wapiti::Dataset.new(input.map { |f| Document.open(f, **opts) }), **opts)
      else
        super(input, **opts)
      end
    end
  end
end
