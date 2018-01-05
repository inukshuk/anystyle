module AnyStyle
  class Feature
    class Category < Feature
      attr_reader :index

      def initialize(index: [0, -1])
        @index = index
      end

      def observe(token, *args)
        index.map { |idx| categorize token.chars[idx] }
      end

      def categorize(char)
        case char
        when /\p{Lu}/
          :Lu
        when /\p{Ll}/
          :Ll
        when /\p{Lm}/
          :Lm
        when /\p{L}/
          :L
        when /\p{M}/
          :M
        when /\p{N}/
          :N
        when /\p{Pc}/
          :Pc
        when /\p{Pd}/
          :Pd
        when /\p{Ps}/
          :Ps
        when /\p{Pe}/
          :Pe
        when /\p{Pi}/
          :Pi
        when /\p{Pf}/
          :Pf
        when /\p{P}/
          :P
        when /\p{S}/
          :S
        when /\p{Zl}/
          :Zl
        when /\p{Zp}/
          :Zp
        when /\p{Z}/
          :Z
        when /\p{C}/
          :C
        else
          :none
        end
      end
    end
  end
end
