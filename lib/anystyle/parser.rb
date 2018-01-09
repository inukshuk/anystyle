module AnyStyle
  class Parser
    include StringUtils

    SUP = File.expand_path('../support', __FILE__).untaint
    RES = File.expand_path('../../../res', __FILE__).untaint

    @formats = [:bibtex, :hash, :citeproc, :wapiti].freeze

    @defaults = {
      model: File.join(SUP, 'parser.mod'),
      pattern: File.join(SUP, 'parser.pat'),
      compact: true,
      threads: 4,
      separator: /(?:\r?\n)+/,
      delimiter: /\s+|\b(\d[^\S]*:)/,
      format: :hash,
      training_data: File.join(RES, 'core.xml')
    }.freeze

    class << self
      attr_reader :defaults, :formats

      def load(path)
        new :model => path
      end

      # Returns a default parser instance
      def instance
        Thread.current[:anystyle] ||= new
      end
    end

    attr_accessor :model
    attr_reader :options, :features, :dictionary, :normalizers

    def initialize(options = {})
      @options = Parser.defaults.merge(options)
      @dictionary = Dictionary.create.open

      @features = [
        Feature::Canonical.new,
        Feature::Category.new,
        Feature::Affix.new,
        Feature::Affix.new(suffix: true),
        Feature::Caps.new,
        Feature::Number.new,
        Feature::Dictionary.new(dictionary: @dictionary),
        Feature::Keyword.new,
        Feature::Position.new,
        Feature::Punctuation.new,
        Feature::Locator.new
      ]

      @normalizers = [
        Normalizer::Quotes.new,
        Normalizer::Punctuation.new,
        Normalizer::Container.new,
        Normalizer::Page.new,
        Normalizer::Date.new,
        Normalizer::Volume.new,
        Normalizer::Location.new,
        Normalizer::Locator.new,
        Normalizer::Names.new,
        Normalizer::Locale.new,
        Normalizer::Type.new
      ]

      reload
    end

    def reload
      @model = Wapiti.load(@options[:model])
      @model.options.update_attributes @options
      self
    end

    def parse(input, format: options[:format])
      case format
      when :wapiti
        label(input)
      when :hash, :bibtex, :citeproc
        formatter = "format_#{format}".to_sym
        send(formatter, label(input))
      else
        raise ArgumentError, "format not supported: #{format}"
      end
    end

    def label(input)
      model.label prepare(input)
    end

    def check(input)
      model.check prepare(input, tagged: true)
    end

    # Prepares the passed-in string for processing by a CRF tagger. The
    # string is split into separate lines; each line is tokenized and
    # expanded. Returns a Wapiti::Dataset.
    def prepare(input, **opts)
      opts[:separator] ||= options[:separator]
      opts[:delimiter] ||= options[:delimiter]

      case input
      when Wapiti::Dataset
        expand input
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

    def expand(dataset)
      dataset.each do |seq|
        seq.tokens.each_with_index do |tok, idx|
          alpha = scrub tok.value
          tok.observations = features.map { |f|
            f.observe tok.value, alpha, idx, seq
          }
        end
      end
    end

    def train(input = options[:training_data], truncate: true)
      if truncate
        @model = Wapiti::Model.new(options.reject { |k,_| k == :model })
      end

      unless input.nil? || input.empty?
        @model.train prepare(input, tagged: true)
      end

      @model.path = options[:model]
      @model
    end

    # Trains the model by appending the training data without
    # truncating the current model.
    # @see train
    def learn(input)
      train(input, truncate: false)
    end

    def normalize(item)
      normalizers.each do |n|
        begin
          n.normalize item unless n.skip?
        rescue => e
          warn "Error in #{n.name} normalizer: #{e.message}"
        end
      end

      item
    end

    private

    # TODO move
    def format_bibtex(dataset)
      require 'bibtex'

      b = BibTeX::Bibliography.new
      format_hash(dataset).each do |hash|
        hash[:bibtex_type] = hash.delete :type

        hash[:type] = hash.delete :genre if hash.key?(:genre)
        hash[:address] = hash.delete :location if hash.key?(:location)
        hash[:urldate] = hash.delete :accessed if hash.key?(:accessed)

        if hash.key?(:authority)
          if [:techreport,:thesis].include?(hash[:bibtex_type])
            hash[:institution] = hash.delete :authority
          else
            hash[:organization] = hash.delete :authority
          end
        end

        b << BibTeX::Entry.new(hash)
      end
      b
    end

    def format_hash(dataset)
      dataset.map { |seq| normalize(seq.to_h(symbolize_keys: true)) }
    end

    def format_citeproc(dataset)
      format_bibtex(dataset).to_citeproc
    end
  end
end
