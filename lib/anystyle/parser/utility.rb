module AnyStyle

  def self.parse(*arguments)
    Parser::Parser.instance.parse(*arguments)
  end

  def self.parser
    Parser::Parser.instance
  end

  def self.dictionary
    parser.dictionary
  end

  module Parser
    def self.instance
      Parser.instance
    end
  end
end
