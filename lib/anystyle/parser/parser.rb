module AnyStyle
  maybe_require 'language_detector'

  DAT = File.expand_path('../../data', __FILE__).untaint
  RES = File.expand_path('../../../../res', __FILE__).untaint

  module Parser

    class Parser
      include StringUtils

      @formats = [:bibtex, :hash, :normalized, :citeproc, :xml, :tags, :raw].freeze

      @defaults = {
        :model => File.join(DAT, 'anystyle.mod'),
        :pattern => File.join(DAT, 'anystyle.pat'),
        :compact => true,
        :threads => 4,
        :separator => /[[:space:]]+|\b(\d[^[:space:]]*:)/,
        :tagged_separator => /[[:space:]]+|(<\/?[^>]+>)/,
        :format => :normalized,
        :training_data => File.join(RES, 'train.txt')
      }.freeze

      class << self

        attr_reader :defaults, :formats

        def load(path)
          new :model => path
        end

        # Returns a default parser instance
        def instance
          @instance ||= new
        end
      end

      attr_reader :options, :features, :dictionary
      attr_accessor :model, :normalizer

      def initialize(options = {})
        @options = Parser.defaults.merge(options)
        @dictionary = Dictionary.create.open

        @features = [
          Feature::Category.new,
          Feature::Affix.new,
          Feature::Affix.new(suffix: true),
          Feature::Canonical.new,
          Feature::Caps.new,
          Feature::Number.new,
          Feature::Dictionary.new(dictionary: @dictionary),
          Feature::Keyword.new,
          Feature::Position.new,
          Feature::Punctuation.new,
          Feature::Locator.new
        ]

        reload

        if defined?(LanguageDetector)
          @lang_detector = LanguageDetector.new
        end

        @normalizer = Normalizer.new
      end

      def reload
        @model = Wapiti.load(@options[:model])
        @model.options.update_attributes @options
        self
      end

      def parse(input, format = options[:format])
        formatter = "format_#{format}".to_sym

        raise ArgumentError, "format not supported: #{formatter}" unless
          respond_to?(formatter, true)

        send(formatter, label(input))
      end

      # Returns an array of label/segment pairs for each line in the passed-in string.
      def label(input, labelled = false)
        model.label(prepare(input, labelled)).map! do |sequence|
          sequence.inject([]) do |ts, (token, label)|
            token, label = token[/^\S+/], label.to_sym
            if (prev = ts[-1]) && prev[0] == label
              prev[1] << ' ' << token
              ts
            else
              ts << [label, token]
            end
          end
        end
      end

      # Returns an array of tokens for each line of input.
      #
      # If the passed-in string is marked as being tagged, extracts labels
      # from the string and returns an array of token/label pairs for each
      # line of input.
      def tokenize(string, tagged = false)
        if tagged
          lines(string).each_with_index.map do |s,i|
            tt, tokens, tags = s.split(options[:tagged_separator]), [], []

            tt.each do |token|
              case token
              when /^$/
                # skip
              when /^<([^\/>][^>]*)>$/
                tags << $1
              when /^<\/([^>]+)>$/
                unless (tag = tags.pop) == $1
                  raise ArgumentError, "mismatched tags on line #{i}: #{$1.inspect} (current tag was #{tag.inspect})"
                end
              else
                tokens << [decode_xml_text(token), (tags[-1] || :unknown).to_sym]
              end
            end

            tokens
          end
        else
          lines(string).map { |s| s.split(options[:separator]).reject(&:empty?) }
        end
      end

      def lines(string)
        string.split(/[ \t]*[\n\r]\s*/)
      end

      # Prepares the passed-in string for processing by a CRF tagger. The
      # string is split into separate lines; each line is tokenized and
      # expanded. Returns an array of sequence arrays that can be labelled
      # by the CRF model.
      #
      # If the string is marked as being tagged by passing +true+ as the
      # second argument, training labels will be extracted from the string
      # and appended after feature expansion. The returned sequence arrays
      # can be used for training or testing the CRF model.
      def prepare(input, tagged = false)
        string = input_to_s(input)
        tokenize(string, tagged).map { |tk| tk.each_with_index.map { |(t,l),i| expand(t,tk,i,l) } }
      end


      # Expands the passed-in token string by appending a space separated list
      # of all features for the token.
      def expand(token, sequence = [], offset = 0, label = nil)
        f = features_for(token, scrub(token), offset, sequence)
        f.unshift(token)
        f.push(label) unless label.nil?
        f.join(' ')
      end

      def train(input = options[:training_data], truncate = true)
        if truncate
          @model = Wapiti::Model.new(options.reject { |k,_| k == :model })
        end

        unless input.nil? || input.empty?
          @model.train(prepare(input, true))
        end

        @model.path = options[:model]
        @model
      end

      # Trains the model by appending the training data without
      # truncating the current model.
      # @see train
      def learn(input)
        train(input, false)
      end

      def test(input)
        model.options.check!
        model.label(prepare(input, true))
      end

      def language(string)
        @lang_detector.detect string
      end

      def normalize(hash)
        hash.keys.each do |label|
          begin
            normalizer.send("normalize_#{label}", hash)
          rescue => e
            warn e.message
          end
        end

        classify hash
        localize hash
      end

      def localize(hash)
        return hash if @lang_detector.nil? || hash.has_key?(:language)

        sample = hash.values_at(
          :title, :booktitle, :location, :publisher
        ).join(' ')

        unless sample.empty?
          hash[:language] = @lang_detector.detect(sample)
        end

        hash
      end

      def classify(hash)
        return hash if hash.has_key?(:type)

        keys = hash.keys
        text = hash.values.flatten.join

        case
        when keys.include?(:journal)
          hash[:type] = :article
        when text =~ /proceedings/i
          hash[:type] = :inproceedings
        when keys.include?(:medium)
          if hash[:medium].to_s =~ /dvd|video|vhs|motion|television/i
            hash[:type] = :motion_picture
          else
            hash[:type] = hash[:medium]
          end
        when keys.include?(:booktitle), keys.include?(:source)
          hash[:type] = :incollection
        when keys.include?(:publisher)
          hash[:type] = :book
        when text =~ /ph(\.\s*)?d|diss(\.|ertation)|thesis/i
          hash[:type] = :thesis
        when text =~ /\b[Pp]atent\b/
          hash[:type] = :patent
        when text =~ /\b[Pp]ersonal [Cc]ommunication\b/
          hash[:type] = :personal_communication
        when keys.include?(:authority)
          hash[:type] = :techreport
        when text =~ /interview/i
          hash[:type] = :interview
        when text =~ /videotape/i
          hash[:type] = :videotape
        when text =~ /unpublished/i
          hash[:type] = :unpublished
        else
          hash[:type] = :misc
        end

        hash
      end

      private

      def input_to_s(input)
        case input
        when String
          if !input.tainted? && input.length < 128 && File.exists?(input)
            f = File.open(input, 'r:UTF-8')
            f.read
          else
            input
          end
        when Array
          input.join("\n")
        else
          raise ArgumentError, "invalid input: #{input.class}"
        end
      ensure
        f.close unless f.nil?
      end

      def features_for(*arguments)
        features.map { |f| f.elicit(*arguments) }
      end

      def format_bibtex(labels)
        b = BibTeX::Bibliography.new
        format_normalized(labels).each do |hash|
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

      def format_raw(labels)
        labels.map do |line|
          line.inject([]) do |tokens, (label, segment)|
            tokens.concat segment.split(' ').map { |token| [label, token] }
          end
        end
      end

      def format_hash(labels)
        labels.map do |line|
          line.inject({}) do |h, (label, token)|
            if h.has_key?(label)
              h[label] = [h[label]].flatten << token
            else
              h[label] = token
            end
            h
          end
        end
      end

      def format_normalized(labels)
        format_hash(labels).map { |h| normalize h }
      end

      def format_citeproc(labels)
        format_bibtex(labels).to_citeproc
      end

      def format_tags(labels)
        labels.map do |line|
          line.map { |label, token| "<#{label}>#{encode_xml_text(token)}</#{label}>" }.join(' ')
        end
      end

      def format_xml(labels)
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, encoding: 'UTF-8'

        xml.references do |rs|
          labels.each do |line|
            rs.reference do |r|
              line.each do |label, segment|
                r.tag! label, segment
              end
            end
          end
        end
      end
    end

  end
end
