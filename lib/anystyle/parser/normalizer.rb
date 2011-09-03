module Anystyle
	module Parser

		class Normalizer

			include Singleton

			def method_missing(name, *arguments, &block)
				case name.to_s
				when /^normalize_(.+)$/
					normalize($1.to_sym, *arguments, &block)
				else
					super
				end
			end

			# Default normalizer. Strips punctuation.
			def normalize(key, hash)
				return hash if hash[key].nil?
				hash[key].gsub!(/^\W+|\W+$/, '')
				hash
			rescue => e
				warn e.message
				hash
			end

			def normalize_author(hash)
				authors = hash[:author]
				
				if authors =~ /\W*[Ee]d(s|itors)?\W*$/ && !hash.has_key?(:editor)
					hash[:editor] = hash.delete(:author)
					normalize_editor(hash)
				else
					authors.gsub!(/^\W+|\W+$/, '')
					hash[:author] = normalize_names(authors)
				end
				
				hash
			rescue => e
				warn e.message
				hash
			end
			
	    def normalize_editor(hash)
	      editors = hash[:editor]
	
				editors.gsub!(/^\W+|\W+$/, '')
				editors.gsub!(/^in\s+/i, '')
				editors.gsub!(/\W*[Ee]d(s|itors)?/, '')
				
	      hash[:editor] = normalize_names(editors)
	      hash
			rescue => e
				warn e.message
				hash
	    end

			def normalize_translator(hash)
				translators = hash[:translator]
				
				translators.gsub!(/^\W+|\W+$/, '')
				translators.gsub!(/\W*trans(lated)?\W*/i, '')
				translators.gsub!(/ by /i, '')
				
				hash[:translator] = normalize_names(translators)
				hash
			rescue => e
				warn e.message
				hash
			end
			
			def normalize_names(names)
				names
			rescue => e
				warn e.message
				hash
			end
			
			def normalize_title(hash)
				title, container = hash[:title]
				
				unless container.nil?
					hash[:container] = container
					normalize(:container, hash)
				end
				#TODO edition in container also
				title.gsub!(/[\.,:;]+$/, '')
				hash[:title] = title
				
				hash
			rescue => e
				warn e.message
				hash
			end
			
			def normalize_booktitle(hash)
				normalize(:booktitle, hash)
				
				booktitle = hash[:booktitle]
				booktitle.gsub!(/^in\s*/i, '')
			
				hash[:booktitle] = booktitle
				
				hash
			rescue => e
				warn e.message
				hash
			end
			
			def normalize_container(hash)
				container = hash[:container]
				
				case container
				when /dissertation abstracts/i
					container.gsub!(/\s*section \w: ([\w\s]+).*$/i, '')
					hash[:category] = $1 unless $1.nil?
					hash[:type] = :phdthesis
				end
				
				hash[:container] = container
				hash
			rescue => e
				warn e.message
				hash
			end
			
			def normalize_date(hash)
				case date = hash[:date]
				when /(\d{4})/
					hash[:year] = $1.to_i
					hash.delete(:date)
				end

				hash
			rescue => e
				warn e.message
				hash
			end

			def normalize_volume(hash)
				case volume = hash[:volume]
				when /\D*(\d+)\D+(\d+[\s&-]+\d+)/
					hash[:volume], hash[:number] = $1.to_i, $2
				when /\D*(\d+)\D+(\d+)/
					hash[:volume], hash[:number] = $1.to_i, $2.to_i
				when /(\d+)/
					hash[:volume] = $1.to_i
				end

				hash
			rescue => e
				warn e.message
				hash
			end

			def normalize_pages(hash)
				# "volume.issue (year):pp"
				case hash[:pages]
				when /(\d+) (?: \.(\d+))? (?: \( (\d{4}) \))? : (\d.*)/x
					hash[:volume] = $1.to_i
					hash[:number] = $2.to_i unless $2.nil?
					hash[:year] = $3.to_i unless $3.nil?
					hash[:pages] = $4
				end

				case hash[:pages]
				when /(\d+)\D+(\d+)/
					hash[:pages] = [$1,$2].join('--')
				when  /(\d+)/
					hash[:pages] = $1
				end
				
				hash
			rescue => e
				warn e.message
				hash
			end


		end

	end
end
