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
               /^(compilador)$/i,
               /編/
            :editor
          when /著|撰/,
            :author
          when /^trans(l(ated|ators?|ation))?$/i,
               /^übers(etz(t|ung))?$/i,
               /^trad(uction|ucteurs?|uit)?$/i,
               /譯/
            :translator
          when /^(dissertation|thesis)$/i
            :thesis
          when /^(proceedings|conference|meeting|transactions|communications|seminar|symposi(on|um))/i
            :proceedings
          when /^(Journal|Zeitschrift|Quarterly|Magazine?|Times|Rev(iew|vue)?|Bulletin|News|Week|Gazett[ea])/
            :journal
          when /^in$/i, /收入/
            :in
          when /^([AaUu]nd|y|e)$/
            :and
          when /^(etal|others)$/
            :etal
          when /^(pp?|pages?|S(eiten?)?|ff?)$/
            :page
          when /^(vol(ume)?s?|iss(ue)?|n[or]?|number|fasc(icle|icule)?|suppl(ement)?|j(ahrgan)?g|heft)$/i
            :volume
          when /^(ser(ies?)?|reihe|[ck]oll(e[ck]tion))$/i
            :series
          when /^patent$/i
            :patent
          when /^report$/i
            :report
          when /^(edn|edition|expanded|rev(ised)?|p?reprint(ed)?|illustrated)$/i,
            /^editio|aucta$/i
            /^(aufl(age)?|\p{Alpha}*ausg(abe)?)$/i
            :edition
          when /^(nd|date|spring|s[uo]mmer|autumn|fall|winter|frühling|herbst)$/i,
               /^(jan(uary?)?|feb(ruary?)?|mar(ch|z)?|apr(il)?|ma[yi]|jun[ei]?)$/,
               /^(jul[yi]?|aug(ust)?|sep(tember)?|o[ck]t(ober)?|nov(ember)?|de[cz](ember)?)$/i,
               /年/
            :date
          when /^(doi|url)/i
            :locator
          when /^(pmid|pmcid)/i
            :pubmed
          when /^(arxiv)/i
            :arxiv
          when /^(retrieved|retirado|accessed|ab(ruf|gerufen))$/i
            :accessed
          when /^[ILXVMCD]{2,}$/
            :roman
          else
            :none
          end
        end
      end
    end
  end
end
