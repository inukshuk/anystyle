module AnyStyle
  class Feature
    class Editor < Feature
      def elicit(token, alpha, offset, sequence)
        sequence.any?(&method(:match?)) ? :editors : :'no-editors'
      end

      # TODO improve patterns / disambiguate edition?
      def match?(token)
        token =~ /^(ed|editor|editors|eds|edited|hrsg)$/i
      end

      def sequence?
        true
      end
    end
  end
end
