module AnyStyle
  class Normalizer
    class Page < Normalizer
      @keys = [:pages]

      def normalize(item)
        map_values(item) do |_, pages|

          # "volume.issue(year):pp"
          case pages
          when /(\d+) (?: \.(\d+))? (?: \( (\d{4}) \))? : (\d.*)/x
            append(item, :volume, $1.to_i)
            append(item, :number, $2.to_i) unless $2.nil?
            append(item, :year, $3.to_i) unless $3.nil?
            pages = $4
          end

          pages.gsub!(/\p{Pd}+/, '–') # en-dash
          pages.gsub!(/[^\d,–]+'/, ' ')
          pages.strip!

          pages
        end
      end
    end
  end
end
