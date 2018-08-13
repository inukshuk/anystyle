module AnyStyle
  class Feature
    class Line < Feature
      def observe(token, page:, seq:, **opts)
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
          ratio(width, page.width),
          classify(chars),
          ratio(seq.line_counts[chars], seq.pages.length)
        ]
      end

      def classify(chars)
        case chars.lstrip
        when /\.\s*\.\s*\.\s*\.|……+/, /\p{L}\s{5,}\d+$/
          :toc
        when /^(\p{Lu}\.?)\s*(\d+\.)+\s+\p{L}+/
          :title
        when /^(\w+\s)?(tab(le|elle|\.)|fig(ure|\.))/i
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
    end
  end
end
