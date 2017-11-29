module AnyStyle
  class Feature
    class Category < Feature
      attr_reader :index

      # TODO support multiple indices?
      def initialize(index: -1)
        @index = index
      end

      def elicit(token, *args)
        categorize(token.chars[index])
      end

      # TODO use more unicode categories
      def categorize(char)
        case char
        when /\p{Lu}/
          :upper
        when /\p{Ll}/
          :lower
        when /\p{N}/
          :numeric
        else
          char
        end
      end
    end
  end
end
