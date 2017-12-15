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
        when /^(proceedings)/i
          :proceedings
        when /^in$/i
          :in
        when /^(retrieved|accessed)$/
          :retrieved
        else
          :none
        end
      end
    end
  end
end
