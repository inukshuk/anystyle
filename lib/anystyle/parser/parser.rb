module Anystyle
	module Parser

		class Parser

			@defaults = {
				:model => File.expand_path('../support/anystyle.mod', __FILE__),
				:pattern => File.expand_path('../support/anystyle.pat', __FILE__),
				:separator => /\s+/
			}.freeze
			
			@features = []

			
			class << self
				
				attr_reader :defaults, :features
				
				def load(path)
					p = new
					p.model = Wapiti.load(path)
					p
				end
								
			end
			
			attr_reader :options
			
			attr_accessor :model
			
			def initialize(options = {})
				@options = Parser.defaults.merge(options)
				@model = Wapiti.load(@options[:model])
			end
			
			def parse(string)
				label(string)
			end
			
			def label(string)
				model.label(prepare(string)) do |token, label|
					[token.split(/\s+/)[0], label]
				end
			end
			
			def tokenize(string)
				string.split(/[\n\r]+/).map { |s| s.split(options[:separator]) }
			end
			
			def prepare(string)
				tokenize(string).map { |tk| tk.each_with_index.map { |t,i| expand(t,tk,i) } }
			end


			def expand(token, sequence, offset)
				features_for(token, sequence, offset).unshift(token).join(' ')
			end
			
			private
			
			def features_for(*arguments)
				Parser.features.map { |f| f.match(*arguments) }
			end
				
		end

	end
end
