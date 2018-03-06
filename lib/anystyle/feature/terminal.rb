module AnyStyle
  class Feature
    class Terminal < Feature
      def observe(token, *args)
        case token
        when /[\.\)\]]["'”„’‚´«‘“`»」』\)\]]?$/,
             /,["'”„’‚´«‘“`»」』\)\]]|["'”„’‚´«‘“`»」』\)\]],$/
          :strong
        when /[:"'”„’‚´«‘“`»」』][,;:\p{Pd}!\?\.]?$/
          :moderate
        when /[!\?,;\p{Pd}]["'”„’‚´«‘“`»」』]?$/
          :weak
        else
          :none
        end
      end
    end
  end
end
