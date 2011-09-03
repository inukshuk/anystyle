module Anystyle
	
	def self.parse(string)
		Parser::Parser.instance.parse(string)
	end
	
	module Parser
		
		def self.instance
			Parser.instance
		end
		
	end
	
end