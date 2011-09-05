module Anystyle
	module Parser
		
		# Dictionary is a Singleton object that provides a key-value store of
		# the Anystyle Parser dictionary required for feature elicitation.
		# This dictionary acts essentially like a Ruby Hash object, but because
		# of the dictionary's size it is not efficient to keep the entire
		# dictionary in memory at all times. For that reason, Dictionary
		# creates a persistent data store on disk using Kyoto Cabinet; if
		# Kyoto Cabinet is not installed a Ruby Hash is used as a fall-back.
		# 
		# The database will be automatically created from the dictionary file
		# using the best available DBM the first time it is accessed. Once
		# database file exists, the database will be restored from file.
		# Therefore, if you make changes to the dictionary file, you will have
		# to delete the old database file for a new one to be created.
		#
		# Database creation requires write permissions. By default, the database
		# will be created in the support directory of the Parser; if you have
		# installed the gem version of the Parser, you may not have write
		# permissions, but you can change the path in the Dictionary's options.
		#
		#     Dictionary.instance.options[:path] # => the database file
		#     Dictionary.instance.options[:source] # => the (zipped) dictionary file
		#
		class Dictionary

			include Singleton
			
			@defaults = {
				:source => File.expand_path('../support/dict.txt.gz', __FILE__),
				:path => File.expand_path('../support/dict.kch', __FILE__)
			}.freeze
			
			@keys = [:male, :female, :surname, :month, :place, :publisher, :journal].freeze

			@code = Hash[*@keys.zip(0.upto(@keys.length-1).map { |i| 2**i }).flatten]
			@code.default = 0
			@code.freeze

			@mode = begin
				require 'kyotocabinet'
				:kyoto
			rescue LoadError
				:hash
			end
			
			class << self
				
				attr_reader :keys, :code, :defaults, :mode
				
			end

			attr_reader :options
			
			def initialize
				@options = Dictionary.defaults.dup
			end
			
			def [](key)
				db[key.to_s].to_i
			end
			
			def []=(key, value)
				db[key.to_s] = value
			end
			
			def create
				case Dictionary.mode
				when :kyoto
					truncate
					@db = KyotoCabinet::DB.new
					unless @db.open(path, KyotoCabinet::DB::OWRITER | KyotoCabinet::DB::OCREATE)
						raise DatabaseError, "failed to create cabinet file #{path}: #{@db.error}"
					end
					populate
					close
				else
					# nothing
				end
			end
			
			def truncate
				close
				File.unlink(path) if File.exists?(path)				
			end
			
			def open
				create unless File.exists?(path)

				case Dictionary.mode
				when :kyoto
					at_exit { ::Anystyle::Parser::Dictionary.instance.close }
	
					@db = KyotoCabinet::DB.new
					unless @db.open(path, KyotoCabinet::DB::OREADER)
						raise DictionaryError, "failed to open cabinet file #{path}: #{@db.error}"
					end
				else
					@db = Hash.new(0)
					populate
				end
				
				@db
			end
			
			def open?; !!@db; end
			
			def close
				@db.close if @db.respond_to?(:close)
				@db = nil
			end
			
			def path
				options[:path]
			end
			
			private
						
			def db
				@db || open
			end
						
			def populate
				require 'zlib'

				File.open(options[:source], 'r:UTF-8') do |f|
					mode = 0

					Zlib::GzipReader.new(f).each do |line|
						line.strip!
						
						if line.start_with?('#')
							case line
							when /^## male/i
								mode = Dictionary.code[:male]
			        when /^## female/i
			          mode = Dictionary.code[:female]
			        when /^## (?:surname|last|chinese)/i
			          mode = Dictionary.code[:surname]
			        when /^## months/i
			          mode = Dictionary.code[:month]
			        when /^## place/i
			          mode = Dictionary.code[:place]
			        when /^## publisher/i
			          mode = Dictionary.code[:publisher]
			        when /^## journal/i
			          mode = Dictionary.code[:journal]
							else
								# skip comments
							end
						else
							key, probability = line.split(/\s+(\d+\.\d+)\s*$/)
							value = self[key]
							self[key] = value + mode if value < mode
						end
					end
				end

			end
						
		end
	
	end
end