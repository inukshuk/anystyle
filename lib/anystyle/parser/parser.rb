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
				ss = string.split(/[\n\r]+/)
				ss.map! { |s| s.split(options[:separator]) }				
				ss
			end
			
			def prepare(string)
				ts = tokenize(string)
				ts.each { |tk| tk.map! { |t| expand(t) } }
				ts
			end


			def expand(token)
				features_for(token).unshift(token).join(' ')
			end
			
			private
			
			def features_for(token)
				Parser.features.map { |f| f.match(token) }
			end
				
		end

	end
end
