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
			
			# TODO add scope binding so that matchers have access to private instance methods
			def match(*arguments)
				matcher.call(*arguments)
			end
						
		end

		### TODO refactor and move to separate class/module or to Feature
		DICT = File.open(File.expand_path('../support/dictionary.txt', __FILE__), 'r:UTF-8') do |f|
			dict = {}
			while line = f.gets
	      line.strip!
	      case line
	        when /^\#\# Male/
	          mode = 1
	        when /^\#\# Female/
	          mode = 2
	        when /^\#\# Last/
	          mode = 4
	        when /^\#\# Chinese/
	          mode = 4
	        when /^\#\# Months/
	          mode = 8
	        when /^\#\# Place/
	          mode = 16
	        when /^\#\# Publisher/
	          mode = 32
	        when (/^\#/)
	          # noop
	        else
	          key = line
	          val = 0
	          # entry has a probability
	          key, val = line.split(/\t/) if line =~ /\t/

	          # some words in dict appear in multiple places
	          unless dict[key] && dict[key] >= mode
	            dict[key] ||= 0
	            dict[key] += mode
	          end
	      end				
			end
			dict.freeze
		end

	  DICT_FLAGS = {
			:publisher =>  32,
	    :place     =>  16,
	    :month     =>  8,
	    :family    =>  4,
	    :female    =>  2,
	    :male      =>  1
		}.freeze
	  
		###
		
		
		# Is the the last character upper-/lowercase, numeric or something else?
		# Returns A, a, 0 or the last character itself.
		Feature.define :last_character do |token|
			case char = token.split(//)[-1]
			when /^[[:upper:]]$/
				?A
			when /^[[:lower:]]$/
				?a
			when /^\d$/
				?0
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
	
		Feature.define :stripped_lowercase do |token|
			s = token.gsub(/[^\w]/, '')
			s.downcase!
			s = :EMPTY if s.empty?
			s
		end
		
		Feature.define :capitalization do |token|
			case token.gsub(/[^\w]/, '')
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
			when /\(\d{4}\)/, /^1\d{3}$/, /^20\d{2}$/
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
		
		# [mode, male, female, family, month, place, publisher]
		Feature.define :dictionary do |token|
			if m = DICT[token.gsub(/[^\w]/, '').downcase]
				[m].concat([:male, :female, :family, :month, :place, :publisher].map { |c| m & DICT_FLAGS[c] > 0 ? c : 'no' })
			else
				%w{ 0 no no no no no no }
			end
		end
		
		# TODO sequence features should be called just once per sequence
		Feature.define :editors do |token, sequence|
			sequence.any? { |t| t =~ /^(ed|editor|editors|eds|edited)$/i } ? :editors : :none
		end

		Feature.define :location do |token, sequence, offset|
			((offset.to_f / sequence.length) * 10).round
		end
		
		Feature.define :punctuation do |token|
			case token
			when /^["'`]/
				:quote
			when /["'`]$/
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

		Feature.define :type do |token, sequence|
			case sequence.join(' ')
			when /proceeding/
				:proceedings
			else
				:other
			end
		end
				
	end
end