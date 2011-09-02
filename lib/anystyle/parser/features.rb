# -*- encoding: utf-8 -*-

module Anystyle
	module Parser

		class Feature
			
			@dict_file = File.expand_path('../support/dictionary.txt', __FILE__)
			
			@dict_keys = [:male, :female, :surname, :month, :place, :publisher].freeze

			@dict_code = Hash[*@dict_keys.zip(0.upto(@dict_keys.length-1).map { |i| 2**i }).flatten]
			@dict_code.default = 0
			@dict_code.freeze
			
			class << self
				
				attr_reader :dict_file, :dict_code, :dict_keys
				
				def dictionary
					@dictionary ||= load_dictionary
				end
				
				alias dict dictionary
				
				def load_dictionary
					File.open(dict_file, 'r:UTF-8') do |f|
						dict, mode = Hash.new(0), 0

						f.each do |line|
							line.strip!

							if line.start_with?(?#)
								case line
								when /^## male/i
									mode = dict_code[:male]
				        when /^## female/i
				          mode = dict_code[:female]
				        when /^## (?:last|chinese)/i
				          mode = dict_code[:surname]
				        when /^## months/i
				          mode = dict_code[:month]
				        when /^## place/i
				          mode = dict_code[:place]
				        when /^## publisher/i
				          mode = dict_code[:publisher]
								else
									# skip comments
								end
							else
								key, probability = line.split(/\s+/)
								dict[key] += mode if mode > dict[key]
							end
						end
						
						dict.freeze
					end
				end
				
				def free_dictionary
					@dictionary = nil
					GC.start
				end
				
			end
			
			def self.define(name, &block)
				Parser.features << new(name, block)
			end
			
			attr_accessor :name, :matcher
			
			def initialize(name, matcher)
				@name, @matcher = name, matcher
			end
			
			def match(*arguments)
				matcher.call(*arguments)
			end
						
		end
		
		
		# Is the the last character upper-/lowercase, numeric or something else?
		# Returns A, a, 0 or the last character itself.
		Feature.define :last_character do |token|
			case char = token.split(//)[-1]
			when /^[[:upper:]]$/
				:A
			when /^[[:lower:]]$/
				:a
			when /^\d$/
				0
			else
				char
			end
		end

		# Sequences of the first four characters
		Feature.define :first do |token|
			c = token.split(//)[0,4]
			(0..3).map { |i| c[0..i].join }
		end
	
		# Sequences of the last four characters
		Feature.define :last do |token|
			c = token.split(//).reverse[0,4]
			(0..3).map { |i| c[0..i].reverse.join }			
		end
	
		Feature.define :stripped_lowercase do |token, stripped|
			stripped.empty? ? :EMPTY : stripped.downcase
		end
		
		Feature.define :capitalization do |token, stripped|
			case stripped
			when /^[[:upper:]]$/
				:single
			when /^[[:upper:]][[:lower:]]/
				:initial
			when /^[[:upper:]]+$/
				:all
			else
				:other
			end
		end
		
		Feature.define :numbers do |token|
			case token
			when /\d+\s*--?\s*\d+/
				:page
			when /^\(\d{4}\)$/, /^(1\d{3}|20\d{2})[\.,;:]?$/
				:year
			when /\d\(\d+\)/
				:volume
			when /^\d$/
				:single
			when /^\d{2}$/
				:double
			when /^\d{3}$/
				:triple
			when /^\d+$/
				:digits
			when /^\d+(th|st|nd|rd)$/i
				:ordinal
			when /\d/
				:numeric
			else
				:none
			end
		end
		
		Feature.define :dictionary do |token, stripped|
			c = Feature.dict[stripped.downcase]
			f = Feature.dict_keys.map { |k| c & Feature.dict_code[k] > 0 ? k : ['no', k].join('-').to_sym }
			f.unshift(c)
		end
		
		# TODO sequence features should be called just once per sequence
		# TODO improve / disambiguate edition
		Feature.define :editors do |token, stripped, sequence|
			sequence.any? { |t| t =~ /^(ed|editor|editors|eds|edited)$/i } ? :editors : :'no-editors'
		end

		Feature.define :location do |token, stripped, sequence, offset|
			((offset.to_f / sequence.length) * 10).round
		end
		
		Feature.define :punctuation do |token|
			case token
			when /^["'”’´‘“`]/
				:quote
			when /["'”’´‘“`]$/
				:unquote
			when /-+/
				:hyphen
			when /[,;:-]$/
				:internal
			when /[!\?\."']$/
				:terminal
			when /^[\(\[\{<].*[>\}\]\)].?$/
				:braces
			when /^\d{2,5}\(\d{2,5}\).?$/
				:volume
			else
				:others
			end
		end


		Feature.define :type do |token, stripped, sequence, offset|
			s = sequence.join(' ')
			case
			when s =~ /proceeding/
				:proceedings
			when stripped =~ /^in$/i && sequence[offset+1].to_s =~ /^[[:upper:]]/ && sequence[offset-1].to_s =~ /["'”’´‘“`\.;,]$/
				:collection
			# TODO thesis article? book unpublished
			else
				:other
			end
		end
				
	end
end