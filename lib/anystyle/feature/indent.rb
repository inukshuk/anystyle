module AnyStyle
  class Feature
    class Indent < Feature
      def observe(token, seq:, idx:, **opts)
        i = indent(token)
        p = prev(idx, seq)
        j = p.nil? ? 0 : indent(p.value)

        [
          (i > 0) ? 'T' : 'F',
          (i < j) ? '-' : (i > j) ? '+' : '=',
        ]
      end
    end
  end
end
