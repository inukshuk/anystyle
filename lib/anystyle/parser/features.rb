module Anystyle
	module Parser

		class Feature
			
			def self.define(name, &block)
				Parser.features << new(name, block)
			end
			
			attr_accessor :name, :matcher
			
			def initialize(name, matcher)
				@name, @matcher = name, matcher
			end
			
			def match(token)
				matcher.call(token)
			end
			
		end
		
		Feature.define :last_character do |token|
			token.split(//)[-1]
		end

	end
end