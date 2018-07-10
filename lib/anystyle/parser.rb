module AnyStyle
  class ParserCore
    include StringUtils

    class << self
      attr_reader :defaults, :formats

      def load(path)
        new :model => path
      end

      # Returns a default parser instance
      def instance
        Thread.current["anystyle_#{name.downcase}"] ||= new
      end
    end

    attr_reader :model, :options, :features, :normalizers

    def initialize(options = {})
      @options = self.class.defaults.merge(options)
      load_model
    end

    def load_model(file = options[:model])
      unless file.nil?
        @model = Wapiti.load(file)
        @model.options.update_attributes options
      else
        @model = Wapiti::Model.new(options.reject { |k,_| k == :model })
        @model.path = options[:model]
      end

      self
    end

    def label(input, **opts)
      model.label prepare(input, **opts)
    end

    def check(input)
      model.check prepare(input, tagged: true)
    end

    def train(input = options[:training_data], truncate: true)
      load_model(nil) if truncate
      unless input.nil? || input.empty?
        model.train prepare(input, tagged: true)
      end
      model
    end

    def learn(input)
      train(input, truncate: false)
    end

    def normalize(hash, **opts)
      normalizers.each do |n|
        begin
          hash = n.normalize(hash, **opts) unless n.skip?
        rescue => e
          warn "Error in #{n.name} normalizer: #{e.message}"
        end
      end
      hash
    end

    def expand(dataset)
      raise NotImplementedError
    end

    def prepare(input, **opts)
      case input
      when Wapiti::Dataset
        expand input
      when Wapiti::Sequence
        expand Wapiti::Dataset.new([input])
      when String
        if !input.tainted? && input.length < 1024 && File.exists?(input)
          expand Wapiti::Dataset.open(input, opts)
        else
          expand Wapiti::Dataset.parse(input, opts)
        end
      else
        expand Wapiti::Dataset.parse(input, opts)
      end
    end
  end


  class Parser < ParserCore
    include Format::BibTeX
    include Format::CSL

    @formats = [:bibtex, :citeproc, :csl, :hash, :wapiti]

    @defaults = {
      model: File.join(SUPPORT, 'parser.mod'),
      pattern: File.join(SUPPORT, 'parser.txt'),
      compact: true,
      threads: 4,
      separator: /(?:\r?\n)+/,
      delimiter: /\s+/,
      format: :hash,
      training_data: File.join(RES, 'parser', 'core.xml')
    }

    def initialize(options = {})
      super(options)

      @features = [
        Feature::Canonical.new,
        Feature::Category.new,
        Feature::Affix.new(size: 2),
        Feature::Affix.new(size: 2, suffix: true),
        Feature::Caps.new,
        Feature::Number.new,
        Feature::Dictionary.new(dictionary: options[:dictionary] || Dictionary.instance),
        Feature::Keyword.new,
        Feature::Position.new,
        Feature::Punctuation.new,
        Feature::Brackets.new,
        Feature::Terminal.new,
        Feature::Locator.new
      ]

      @normalizers = [
        Normalizer::Unicode.new,
        Normalizer::Quotes.new,
        Normalizer::Brackets.new,
        Normalizer::Punctuation.new,
        Normalizer::Journal.new,
        Normalizer::Container.new,
        Normalizer::Edition.new,
        Normalizer::Volume.new,
        Normalizer::Page.new,
        Normalizer::Date.new,
        Normalizer::Location.new,
        Normalizer::Locator.new,
        Normalizer::Publisher.new,
        Normalizer::PubMed.new,
        Normalizer::Names.new,
        Normalizer::Locale.new,
        Normalizer::Type.new
      ]
    end

    def expand(dataset)
      dataset.each do |seq|
        seq.tokens.each_with_index do |tok, idx|
          alpha = scrub tok.value
          tok.observations = features.map { |f|
            f.observe tok.value, alpha: alpha, idx: idx, seq: seq
          }
        end
      end
    end

    def format_hash(dataset, symbolize_keys: true)
      dataset.inject([]) { |out, seq|
        out << normalize(seq.to_h(symbolize_keys: symbolize_keys), prev: out)
      }
    end

    def flatten_values(hash, skip: [], spacer: ' ')
      hash.each_pair do |key, value|
        unless !value.is_a?(Array) || skip.include?(key)
          if value.length > 1 && value[0].respond_to?(:join)
            hash[key] = value.join(spacer)
          else
            hash[key] = value[0]
          end
        end
      end
    end

    def rename_value(hash, name, new_name)
      hash[new_name] = hash.delete name if hash.key?(name)
    end

    def parse(input, format: options[:format], **opts)
      case format.to_sym
      when :wapiti
        label(input, **opts)
      when :hash, :bibtex, :citeproc, :csl
        formatter = "format_#{format}".to_sym
        send(formatter, label(input, **opts), **opts)
      else
        raise ArgumentError, "format not supported: #{format}"
      end
    end

    def prepare(input, **opts)
      opts[:separator] ||= options[:separator]
      opts[:delimiter] ||= options[:delimiter]
      input = input.join("\n") if input.is_a?(Array) && input[0].is_a?(String)
      super(input, opts)
    end
  end
end
