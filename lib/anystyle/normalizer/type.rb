module AnyStyle
  class Normalizer
    class Type < Normalizer
      def normalize(item)
        item[:type] = classify item
        item
      end

      def classify(item)
        keys = item.keys

        case
        when keys.include?(:journal)
          'article'
        when keys.include?(:'container-title')
          if item[:'container-title'].to_s =~ /Proceedings|Proc\./
            'paper-conference'
          else
            'chapter'
          end
        when keys.include?(:genre)
          case item[:genre].to_s
          when /ph(\.\s*)?d|diss(\.|ertation)|thesis/i
            'thesis'
          when /rep(\.|ort)/i
            'report'
          when /unpublished|manuscript/i
            'manuscript'
          when /patent/i
            'patent'
          when /personal communication/i
            'personal_communication'
          when /interview/i
            'interview'
          end
        when keys.include?(:medium)
          if item[:medium].to_s =~ /dvd|video|vhs|motion/i
            'motion_picture'
          elsif item[:medium].to_s =~ /television/i
            'broadcast'
          else
            item[:medium]
          end
        when keys.include?(:publisher)
          'book'
        end
      end
    end
  end
end
