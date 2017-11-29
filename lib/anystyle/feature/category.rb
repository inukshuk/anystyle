module AnyStyle
  class Feature
    class Category < Feature
      attr_reader :index

      def initialize(index: -1)
        @index = index
      end

      def elicit(token, *args)
        categorize(token.chars[index])
      end

      def categorize(char)
        case char
        when /\p{P}/
          char
        when /\p{N}/
          :number
        when /\p{Upper}/
          :upper
        when /\p{Lower}/
          :lower
        else
          :other
        end
      end
    end
  end
end
