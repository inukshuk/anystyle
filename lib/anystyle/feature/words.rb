module AnyStyle
  class Feature
    class Words < Feature
      def observe(token, **opts)
        [
          count(token, /[\p{L}\p{N}_-]+/),
          count(token, /\d+(\.\d+)?/)
        ]
      end
    end
  end
end
