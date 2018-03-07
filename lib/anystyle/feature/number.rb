module AnyStyle
  class Feature
    class Number < Feature
      def observe(token, *args)
        case token
        when /\d[\(:;]\d/
          :volume
        when /\b(1\d|20)\d\d\b/
          :year
        when /\d[—–-]+\d/
          :range
        when /^\d\d\d\d$/
          :quad
        when /^\d\d\d$/
          :triple
        when /^\d\d$/
          :double
        when /^\d$/
          :single
        when /^\d+$/
          :all
        when /^\d+[\d-]+$/
          :serial
        when /\d\p{Alpha}{1,3}\b/i
          :ordinal
        when /\d/
          :numeric
        when /^([IVXLDCM]+|[ivx]+)\b/
          :roman
        else
          :none
        end
      end
    end
  end
end
