module AnyStyle
  class Feature
    class Brackets < Feature
      def observe(token, alpha, offset, sequence)
        case token
        when /^[^\(\[\)\]]+$/
          :none
        when /^\(.*\)[,;:\p{Pd}!\?\.]?$/
          :parens
        when /^\[.*\][,;:\p{Pd}!\?\.]?$/
          :'square-brackets'
        when /\)[,;:\p{Pd}!\?\.]?$/
          :'closing-paren'
        when /^\(/
          :'opening-paren'
        when /\][,;:\p{Pd}!\?\.]?$/
          :'closing-square-bracket'
        when /^\[/
          :'opening-square-bracket'
        else
          :other
        end
      end
    end
  end
end
