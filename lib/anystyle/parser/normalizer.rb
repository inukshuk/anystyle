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

			def normalize(key, hash)
				return hash if hash[key].nil?

				hash[key].gsub!(/^\W+|\W+$/, '')
				hash
			end

			def normalize_date(hash)
				case date = hash[:date]
				when /(\d{4})/
					hash[:year] = $1.to_i
					hash.delete(:date)
				end

				hash
			end

			def normalize_volume(hash)
				case volume = hash[:volume]
				when /\D*(\d+)\D+(\d+)/
					hash[:volume], hash[:number] = $1.to_i, $2.to_i

				when /(\d+)/
					hash[:volume] = $1.to_i
				end

				hash
			end

			def normalize_pages(hash)
				# taken from freecite
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
			end


		end

	end
end
