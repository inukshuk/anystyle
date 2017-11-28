module Anystyle
  class Feature
    class Editor < Feature
      def elicit(_, sequence:)
        sequence.any? { |token| match?(token) ? :editors : :'no-editors' }
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
