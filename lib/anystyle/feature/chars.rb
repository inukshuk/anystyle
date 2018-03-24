module AnyStyle
  class Feature
    class Chars < Feature
      def observe(token, page:, **opts)
        chars = count(token, /\p{L}/)
        upper = count(token, /\p{Lu}/)
        white = count(token, /\s/)
        punct = count(token, /[\p{Pd}:.,&\(\)"'”„’‚´«「『‘“`»」』]/)
        width = display_width(token)

        [
          chars,
          width,
          ratio(upper, chars),
          ratio(white, chars),
          ratio(punct, chars),
          ratio(width, page.width)
        ]
      end
    end
  end
end
