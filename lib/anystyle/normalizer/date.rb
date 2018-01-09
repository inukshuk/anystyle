module AnyStyle
  class Normalizer
    class Date < Normalizer
      @keys = [:date]

      def normalize(item)
        map_values(item) do |_, value|
          unless (month = MONTH[value]).nil?
            month = '%02d' % month
          end

          if value =~ /(\d{4})/
            year = $1

            if month && value =~ /\b(\d{1,2})\b/
              day = '%02d' % $1.to_i
            end

            [year, month, day].compact.join('-')
          else
            value
          end
        end
      end

      MONTH = Hash.new do |h,k|
        case k
        when /jan/i
          h[k] = 1
        when /feb/i
          h[k] = 2
        when /mar/i
          h[k] = 3
        when /apr/i
          h[k] = 4
        when /ma[yi]/i
          h[k] = 5
        when /jun/i
          h[k] = 6
        when /jul/i
          h[k] = 7
        when /aug/i
          h[k] = 8
        when /sep/i
          h[k] = 9
        when /o[ck]t/i
          h[k] = 10
        when /nov/i
          h[k] = 11
        when /dec/i
          h[k] = 12
        else
          h[k] = nil
        end
      end
    end
  end
end
