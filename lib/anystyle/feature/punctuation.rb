module AnyStyle
  class Feature
    class Punctuation < Feature
      # TODO Review and use unicode category patterns
      def elicit(token, alpha, offset, sequence)
        case token
        when /^\p{^P}+$/
          :none
        when /^["'”’´‘“`]/
          :quote
        when /["'”’´‘“`][!\?\.]$/
          :'terminal-unquote'
        when /["'”’´‘“`][,;:-]$/
          :'internal-unquote'
        when /["'”’´‘“`]$/
          :unquote
        when /^[\[\{].*[\}\]][!\?\.,;:-]?$/
          :braces
        when /^<.*>[!\?\.,;:-]?$/
          :tags
        when /^[\(].*[\)][!\?\.]$/
          :'terminal-parens'
        when /^\(.*\)[,;:-]$/
          :'internal-parens'
        when /^\(.*\)$/
          :parens
        when /^[\[\{]/
          :'opening-brace'
        when /[\}\]][!\?\.,;:-]?$/
          :'closing-brace'
        when /^</
          :'opening-tag'
        when />[!\?\.,;:-]?$/
          :'closing-tag'
        when /^\(/
          :'opening-parens'
        when /\)[,;:-]$/
          :'internal-closing-parens'
        when /^\)$/
          :'closing-parens'
        when /[,;:-]$/
          :internal
        when /[!\?\."']$/
          :terminal
        when /^\d{2,5}\(\d{2,5}\).?$/
          :volume
        when /-+/
          :hyphen
        else
          :other
        end
      end
    end
  end
end
