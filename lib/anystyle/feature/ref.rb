module AnyStyle
  class Feature
    class Ref < Feature
      def observe(token, **opts)
        [
          symbolize(count(token, /\b(1[4-9]|20)\d\d\b/)),
          symbolize(count(token, /(\d[\(:;]\d)|(\d\s*\p{Pd}+\s*\d)|\bpp?\.|\bvols?\.|\b(nos?|nr|iss?|fasc)\.|n°|nº/i)),
          symbolize(count(token, /\b\p{Lu}\./)),
          symbolize(count(token, /\b(eds?\.|edited by|editors?|hg|hrsg|et al)\b/i)),
          token =~ /^\s*(\[\w+\]|\(\d+\)|\d+\.)\s+/ ? 'T' : 'F'
        ]
      end

      def symbolize(k)
        return '-' if k < 1
        return '+' if k < 2
        return '*'
      end
    end
  end
end
