module Anystyle

  def self.parse(*arguments)
    Parser::Parser.instance.parse(*arguments)
  end

  def self.parser
    Parser::Parser.instance
  end

  def self.dictionary
    Parser::Dictionary.instance
  end

  # Create a new Anystyle parser, training it using the marked-up
  # training data contained in _training_file_
  def self.train_parser(training_file)
    training_data = File.read(training_file, encoding: "UTF-8")
    Parser::Parser::train_new(training_data)
  end
  
  # Load an Anystyle parser, using the saved Wapiti model contained in
  # model_file.
  def self.load_parser(model_file)
    Parser::Parser::load(model_file)
  end
  
  module Parser
    def self.instance
      Parser.instance
    end

  end

end
