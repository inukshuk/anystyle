module AnyStyle
  class Feature
    class Line < Feature
      def observe(token, page:, seq:, **opts)
        chars = display_chars(token)

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
          ratio(width, page.width),
          classify(chars),
          page_ratio(seq.line_counts[chars], seq.pages.length),
          page_ratio(seq.nnum_counts[nnum(chars)], seq.pages.length)
        ]
      end

      def classify(chars)
        case chars.lstrip
        when /\.\s*\.\s*\.\s*\.|……+/, /\p{L}\s{5,}\d+$/
          :toc
        when /^[\[\(]?\d+\.?[\]\)]?\s+\p{L}+/
          :list
        when /^(\p{Lu}\.?)\s*(\d+\.)+\s+\p{L}+/
          :title
        when /^(\w+\s)?(tab(le|elle|\.)|fig(ure|\.)|equation|graph|abb(ildung)?)/i
          :cap
        when /^\p{Pd}?\d+\p{Pd}?$/, /^[ivx]+$/i
          :num
        when /copyright|©|rights reserved/i
          :copyright
        when /https?:\/\//i
          :http
        else
          :none
        end
      end

      def page_ratio(a, b)
        r = a.to_f / b
        r == 1 ? '=' : r > 1 ? '+' : (r * 10).round
      end
    end
  end
end
