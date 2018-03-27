module AnyStyle
  class Feature
    class Line < Feature
      def observe(token, page:, **opts)
        chars = display_chars(token).rstrip

        lttrs = count(chars, /\p{L}/)
        upper = count(chars, /\p{Lu}/)
        punct = count(chars, /[\p{Pd}:.,&\(\)"'”„’‚´«「『‘“`»」』]/)
        white = count(chars, /\s/)
        width = chars.length

        [
          lttrs,
          width,
          ratio(upper, lttrs),
          ratio(lttrs, chars.length),
          ratio(white, chars.length),
          ratio(punct, chars.length),
          ratio(width, page.width)
        ]
      end
    end
  end
end
