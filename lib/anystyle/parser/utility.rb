module Anystyle
	
	def self.parse(*arguments)
		Parser::Parser.instance.parse(*arguments)
	end
	
	module Parser
		
		def self.instance
			Parser.instance
		end
		
	end
	
end