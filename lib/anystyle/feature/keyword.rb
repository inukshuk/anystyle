module AnyStyle
  class Feature
    class Keyword < Feature
      def observe(token, alpha: token, **opts)
        case token
        when '&'
          :and
        else
          case alpha
          when /^ed(s|itors?|ited?|iteurs?)?$/i,
               /^(hg|hrsg|herausgeber)$/i,
               /^(compilador)$/i
            :editor
          when /^trans(l(ated|ators?|ation))?$/i,
               /^übers(etz(t|ung))?$/i,
               /^trad(uction|ucteurs?|uit)?$/i
            :translator
          when /^(dissertation|thesis)$/i
            :thesis
          when /^(proceedings|conference|meeting|transactions|communications|seminar|symposi(on|um))/i
            :proceedings
          when /^(Journal|Zeitschrift|Quarterly|Magazine?|Times|Rev(iew|vue)?|Bulletin|News|Week)/
            :journal
          when /^in$/i
            :in
          when /^([AaUu]nd|y|e)$/
            :and
          when /^(etal|others)$/
            :etal
          when /^(pp?|pages?|S(eiten?)?|ff?)$/
            :page
          when /^(vol(ume)?s?|iss(ue)?|n[or]?|number)$/i
            :volume
          when /^(ser(ies?)?|reihe)$/i
            :series
          when /^(edn|edition|expanded|rev(ised)?|p?reprint(ed)?|illustrated)$/i,
            /^(aufl(age)?|\p{Alpha}*ausg(abe)?)$/i
            :edition
          when /^(nd|date|spring|s[uo]mmer|autumn|fall|winter|frühling|herbst)$/i,
               /^(jan(uary?)?|feb(ruary?)?|mar(ch|z)?|apr(il)?|ma[yi]|jun[ei]?)$/,
               /^(jul[yi]?|aug(ust)?|sep(tember)?|o[ck]t(ober)?|nov(ember)?|de[cz](ember)?)$/i
            :date
          when /^(pmid|pmcid|arxiv|doi|url)/i
            :locator
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
