module AnyStyle
  class Feature
    class Brackets < Feature
      def observe(token, alpha, offset, sequence)
        case token
        when /^[^\(\[\)\]]+$/
          :none
        when /^\(.*\)[,;:-!\?\.]?$/
          :parens
        when /^\[.*\][,;:-!\?\.]?$/
          :'square-brackets'
        when /^\(/
          :'opening-paren'
        when /\)[,;:-!\?\.]?$/
          :'closing-paren'
        when /^\[/
          :'opening-square-bracket'
        when /\][,;:-!\?\.]?$/
          :'closing-square-bracket'
        else
          :other
        end
      end
    end
  end
end
