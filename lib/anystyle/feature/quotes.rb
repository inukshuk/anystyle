module AnyStyle
  class Feature
    class Quotes < Feature
      def observe(token, alpha, offset, sequence)
        case token
        when /^[^"'”„’‚´«「『‘“`»」』]+$/
          :none
        when /^["'”„’‚´«「『‘“`»].*["'”„’‚´«‘“`»」』][,;:-!\?\.]?$/
          :'quote-unquote'
        when /^["'”„’‚´«「『‘“`»]/
          :quote
        when /["'”„’‚´«‘“`»」』][,;:-!\?\.]?$/
          :unquote
        else
          :other
        end
      end
    end
  end
end
