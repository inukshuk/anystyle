module AnyStyle
  class Feature
    class Ref < Feature
      def observe(token, **opts)
        [
          symbolize(count(token, /\b(1\d|20)\d\d\b/)),
          symbolize(count(token, /(\d[\(:;]\d)|(\d\s*[—–-]+\s*\d)|\bpp?\.|\bvols?\./i)),
          symbolize(count(token, /\b\p{Lu}\./)),
          symbolize(count(token, /\b(eds?\.|edited by|editors?|hg|hrsg|et al)\b/i)),
          token =~ /^\s*\[\d+\]/ ? 'T' : 'F'
        ]
      end

      def symbolize(k)
        return '-' if k < 1
        return '+' if k < 3
        return '++'
      end
    end
  end
end
