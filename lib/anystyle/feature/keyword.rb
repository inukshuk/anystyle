module AnyStyle
  class Feature
    class Keyword < Feature
      def observe(token, alpha, *args)
        case token
        when '&'
          :and
        else
          case alpha
          when /^(ed|editor|editors|eds|edited)$/i,
               /^(hg|hrsg|herausgeber)$/i,
               /^(compilador)$/i
            :editor
          when /^(trans(lated)?|translation)$/i,
               /^(übers(etzung)?)$/i,
               /^(trad(uction)?)$/i
            :translator
          when /^(dissertation|thesis)$/i
            :thesis
          when /^(proceedings|conference|meeting)/i
            :proceedings
          when /^(journal|zeitschrift|quarterly|review|revue)/i
            :journal
          when /^in$/i
            :in
          when /^(and|und)$/
            :and
          when /^(etal)$/
            :etal
          when /^(pp?|pages?|S(eiten?)?|ff?)$/
            :page
          when /^(vol(ume)?s?|iss(ue)?|n[or]?|number)$/i
            :volume
          when /^(edn|edition|expanded|rev(ised)?|p?reprint|illustrated)$/i,
            /^(aufl(age)?|\p{Alpha}*ausg(abe)?)$/i
            :edition
          when /^(spring|s[uo]mmer|autumn|fall|winter|frühling|herbst)$/i,
               /^(jan(uary?)?|feb(ruary?)?|mar(ch|z)?|apr(il)?|ma[yi]|jun[ei]?)$/,
               /^(jul[yi]?|aug(ust)?|sep(tember)?|o[ck]t(ober)?|nov(ember)?|de[cz](ember)?)$/i
            :date
          when /^(retrieved|accessed)$/i
            :accessed
          else
            :none
          end
        end
      end
    end
  end
end
