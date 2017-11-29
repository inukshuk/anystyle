module AnyStyle
  class Feature
    class PubType < Feature
      # TODO sequence or token feature?
      # TODO improve or remove?
      def elicit(token, alpha, offset, sequence)
        s = sequence.join(' ')
        case
        when s =~ /dissertation abstract/i
          :dissertation
        when s =~ /proceeding/i
          :proceedings
        when alpha =~ /^in$/i && sequence[offset+1].to_s =~ /^[[:upper:]]/ && sequence[offset-1].to_s =~ /["'”’´‘“`\.;,]$/
          :collection
        else
          :other
        end
      end

      #def sequence?
      #  true
      #end
    end
  end
end
