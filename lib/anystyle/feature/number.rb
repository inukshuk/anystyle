module AnyStyle
  class Feature
    class Number < Feature
      def observe(token, *args)
        case token
        when /\b(1\d|20)\d\d\b/
          :year
        when /\d+[\(\.]\d+/
          :volume
        when /^\d+$/
          :digits
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
