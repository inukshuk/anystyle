module Anystyle

  def self.parse(*arguments)
    Parser::Parser.instance.parse(*arguments)
  end

  def self.parser
    Parser::Parser.instance
  end

  module Parser

    def self.instance
      Parser.instance
    end

  end

end
