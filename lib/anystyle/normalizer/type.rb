module AnyStyle
  class Normalizer
    class Type < Normalizer
      def normalize(item, **opts)
        item[:type] = classify item unless item.key?(:type)
        item
      end

      def classify(item)
        keys = item.keys

        case
        when keys.include?(:'container-title')
          case
          when keys.include?(:issue)
            'article-journal'
          when item[:'container-title'].to_s =~ /proceedings|proc\.|conference|meeting|symposi(on|um)/i
            'paper-conference'
          when item[:'container-title'].to_s =~ /journal|zeitschrift|quarterly|review|revue/i
            'article-journal'
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
          when /web|online|en ligne/
            'webpage'
          end
        when keys.include?(:medium)
          case item[:medium].to_s
          when /dvd|video|vhs|motion/i
            'motion_picture'
          when /television/i
            'broadcast'
          end
        when keys.include?(:publisher)
          'book'
        end
      end
    end
  end
end
