module AnyStyle
  class Feature
    class Ref < Feature
      def observe(token, **opts)
        [
          count(token, /\b(1\d|20)\d\d\b/),
          count(token, /(\d[\(:;]\d)|(\d\s*[—–-]+\s*\d)/),
          count(token, /\b\p{Lu}\./)
        ]
      end
    end
  end
end
