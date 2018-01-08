module AnyStyle
  class Normalizer
    class Type < Normalizer
      def normalize(item)
        item[:type] = classify item
      end

      def classify(item)
        keys = item.keys
        text = item.values.flatten.join

        case
        when keys.include?(:journal)
          'article'
        when keys.include?(:booktitle)
          if item[:booktitle].to_s =~ /Proceedings|Proc\./
            'paper-conference'
          else
            'chapter'
          end
        when keys.include?(:publisher)
          'book'
        when text =~ /ph(\.\s*)?d|diss(\.|ertation)|thesis/i
          'thesis'
        when keys.include?(:medium)
          if item[:medium].to_s =~ /dvd|video|vhs|motion|television/i
            'motion_picture'
          else
            item[:medium]
          end
        when keys.include?(:authority)
          'report'
        when text =~ /\b[Pp]atent\b/
          'patent'
        when text =~ /\b[Pp]ersonal [Cc]ommunication\b/
          'personal_communication'
        when text =~ /interview/i
          'interview'
        when text =~ /unpublished|manuscript/i
          'manuscript'
        end
      end
    end
  end
end
