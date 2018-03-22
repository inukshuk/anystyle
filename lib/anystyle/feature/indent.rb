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

      def indent(token)
        token =~ /^(\s*)/
        $1.length
      end
    end
  end
end
