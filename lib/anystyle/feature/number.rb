module AnyStyle
  class Feature
    class Number < Feature
      def observe(token, **opts)
        case token
        when /\d[\(:;]\d/
          :volume
        when /^97[89](\p{Pd}?\d){10}$/,
             /^\d(\p{Pd}?\d){9}$/
          :isbn
        when /\b(1\d|20)\d\d\b/
          :year
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
        when /^\d+\p{Pd}+\d+$/
          :range
        when /^\p{Lu}[\p{Lu}\p{Pd}\/]+\d+[,.:]?$/
          :idnum
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
