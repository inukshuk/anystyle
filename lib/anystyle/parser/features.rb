# -*- encoding: utf-8 -*-

module Anystyle
	module Parser

		class Feature
			
			@defaults = {
				:dict => File.expand_path('../support/dict.txt.gz', __FILE__),
				:db => File.expand_path('../support/dict.kch', __FILE__)			
			}
			
			@dict_keys = [:male, :female, :surname, :month, :place, :publisher].freeze

			@dict_code = Hash[*@dict_keys.zip(0.upto(@dict_keys.length-1).map { |i| 2**i }).flatten]
			@dict_code.default = 0
			@dict_code.freeze
			
			class << self
				
				attr_reader :dict_code, :dict_keys, :defaults
				
				def dict
					@dict ||= open_dictionary
				end
				
				alias dictionary dict
				
				def dict_open?; !!@dict; end
				
				def close_dictionary
					dict.close if dict_open?
				end
				
				def open_dictionary(file = defaults[:db])
					create_dictionary(file) unless File.exists?(file)
					
					db = KyotoCabinet::DB.new
					unless db.open(file, KyotoCabinet::DB::OREADER)
						raise DatabaseError, "failed to open cabinet file #{file}: #{db.error}"
					end
					
					at_exit { ::Anystyle::Parser::Feature.close_dictionary }
					db
				end
				
				def create_dictionary(db = defaults[:db], file = defaults[:dict])
					require 'zlib'
					
					close_dictionary
					File.unlink(db) if File.exists?(db)
						
					kc = KyotoCabinet::DB.new
					unless kc.open(db, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
						raise DatabaseError, "failed to create cabinet file #{db}: #{kc.error}"
					end
					
					File.open(file, 'r:UTF-8') do |f|
						mode = 0

						Zlib::GzipReader.new(f).each do |line|
							line.strip!

							if line.start_with?(?#)
								case line
								when /^## male/i
									mode = dict_code[:male]
				        when /^## female/i
				          mode = dict_code[:female]
				        when /^## (?:surname|last|chinese)/i
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
								key, probability = line.split(/\s+(\d+\.\d+)\s*$/)
								value = kc[key].to_i
								kc[key] = value + mode if value < mode
							end
						end
					end
					
					kc.close
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
				:upper
			when /^[[:lower:]]$/
				:lower
			when /^\d$/
				:numeric
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
			when /^\(\d{4}\)\W*$/, /^(1\d{3}|20\d{2})[\.,;:]?$/
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
			when /\d+(th|st|nd|rd)\W*/i
				:ordinal
			when /\d/
				:numeric
			else
				:none
			end
		end
		
		Feature.define :dictionary do |token, stripped|
			c = Feature.dict[stripped.downcase].to_i
			f = Feature.dict_keys.map do |k|
				c & Feature.dict_code[k] > 0 ? k : ['no',k].join('-').to_sym
			end
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