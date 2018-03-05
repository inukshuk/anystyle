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
  end
end
