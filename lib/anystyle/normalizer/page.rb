module AnyStyle
  class Normalizer
    class Page < Normalizer
      @keys = [:pages]

      def normalize(item, **opts)
        map_values(item) do |_, value|
          pages = case value
            when /(\d+)(?:\.(\d+))?(?:\((\d{4})\))?:(\d.*)/
              # "volume.issue(year):pp"
              append(item, :volume, $1.to_i)
              append(item, :issue, $2.to_i) unless $2.nil?
              append(item, :year, $3.to_i) unless $3.nil?
              $4
            else
              value
            end

          pages
            .gsub(/\p{Pd}+/, '–')
            .gsub(/[^\d,–]+/, ' ')
            .strip
        end
      end
    end
  end
end
