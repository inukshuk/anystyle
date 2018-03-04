module AnyStyle
  class Feature
    class Keyword < Feature
      def observe(token, alpha, *args)
        case alpha
        when /^(ed|editor|editors|eds|edited)$/i,
             /^(hrsg|herausgeber)$/i
          :editor
        when /^(trans|translated)$/i
          :translator
        when /^(dissertation)$/i
          :thesis
        when /^(review)$/i
          :review
        when /^(proceedings|conference)/i
          :proceedings
        when /^(journal|zeitschrift|quarterly)/i
          :journal
        when /^in$/i
          :in
        when /^(and|und|&)$/
          :and
        when /^(etal)$/
          :etal
        when /^(retrieved|accessed)$/i
          :retrieved
        when /^(edition|expanded|revised|p?reprint|illustrated)$/i,
          /^(aufl(age)?|\p{Alpha}*ausg(abe)?)$/i
          :edition
        else
          :none
        end
      end
    end
  end
end
