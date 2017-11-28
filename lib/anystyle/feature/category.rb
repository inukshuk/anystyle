module Anystyle
  class Feature
    class Category < Feature
      attr_reader :index

      # TODO support multiple indices
      def initalize(index: -1, **options)
        super(**options)
        @index = index
      end

      def elicit(token)
        classify(token[index])
      end

      # TODO use more unicode categories
      def classify(char)
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
