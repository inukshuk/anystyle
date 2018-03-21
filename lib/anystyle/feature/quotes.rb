module AnyStyle
  class Feature
    class Quotes < Feature
      def observe(token, **opts)
        case token
        when /^[^"'”„’‚´«「『‘“`»」』]+$/
          :none
        when /^["'”„’‚´«「『‘“`»].*["'”„’‚´«‘“`»」』][,;:\p{Pd}!\?\.]?$/
          :'quote-unquote'
        when /^["'”„’‚´«「『‘“`»]/
          :quote
        when /["'”„’‚´«‘“`»」』][,;:\p{Pd}!\?\.]?$/
          :unquote
        else
          :other
        end
      end
    end
  end
end
