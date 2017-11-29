module AnyStyle
  class Feature
    class Number < Feature
      # TODO check/improve patterns
      def elicit(token, *args)
        case token
        when /\d\(\d+([—–-]\d+)?\)/
          :volume
        when /^\(\d{4}\)[^[:alnum:]]*$/, /^(1\d{3}|20\d{2})[\.,;:]?$/
          :year
        when /\d{4}\s*[—–-]+\s*\d{4}/
          :'year-range'
        when /\d+\s*[—–-]+\s*\d+/, /^[^[:alnum:]]*pp?\.\d*[^[:alnum:]]*$/, /^((pp?|s)\.?|pages?)$/i
          :page
        when /^\d$/
          :single
        when /^\d{2}$/
          :double
        when /^\d{3}$/
          :triple
        when /^\d+$/
          :digits
        when /^\d+[\d-]+$/
          :serial
        when /^-\d+$/
          :negative
        when /\d+(th|st|nd|rd)[^[:alnum:]]*/i
          :ordinal
        when /\d/
          :numeric
        else
          :none
        end
      end
    end
  end
end
