module Anystyle
	
	def self.parse(string)
		Parser::Parser.instance.parse(string)
	end
	
end