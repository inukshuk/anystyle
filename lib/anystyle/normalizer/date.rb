module AnyStyle
  class Normalizer
    class Date < Normalizer
      @keys = [:date]

      def normalize(item, **opts)
        map_values(item) do |_, value|
          case
          when unknown?(value)
            'XXXX'
          when interval?(value)
            value
          # TODO AD/BC
          # TODO Seasons
          when iso?(value)
            value
          else
            year = extract_year(value)
            unless year.nil?
              month = extract_month_by_name(value)
              day = extract_day(value) unless month.nil?
              [
                [year, month, day].compact.join('-'),
                extract_uncertainty(value)
              ].compact.join('')
            else
              value
            end
          end
        end
      end

      def iso?(date)
        date =~ /[012]\d\d\d-\d\d-\d\d/
      end

      def interval?(date)
        date =~ /\/|\s\p{Pd}\s|(\s([12]?\d|30)\p{Pd}([12]?\d|3[01])?)/
      end

      def unknown?(date)
        date =~ /inconnue|unknown|unbekannt|[ns]\. ?d\b|no date/i
      end

      def uncertain?(date)
        date =~ /\?/
      end

      def approximate?(date)
        date =~ /(\b(circa|ca\.|vers|approx))|(^[cv]\.)/i
      end

      def extract_uncertainty(date)
        if approximate?(date)
          uncertain?(date) ? '%' : '~'
        else
          uncertain?(date) ? '?' : nil
        end
      end

      def extract_year(date)
        if date =~ /\D?([012]\d\d\d)\D?/
          $1
        else
          nil
        end
      end

      def extract_day(date)
        if date =~ /\b([012]?\d|3[01])\b/
          '%02d' % $1.to_i
        else
          nil
        end
      end

      def extract_month_by_name(date)
        case date
        when /\bjan/i
          '01'
        when /\bf(eb|év)/i
          '02'
        when /\bmar/i
          '03'
        when /\ba[pv]r/i
          '04'
        when /\bma[yi]/i
          '05'
        when /\bjui?n/i
          '06'
        when /\bjui?l/i
          '07'
        when /\ba(ug|oût)/i
          '08'
        when /\bsep/i
          '09'
        when /\bo[ck]t/i
          '10'
        when /\bnov/i
          '11'
        when /\bd[eé]c/i
          '12'
        else
          nil
        end
      end
    end
  end
end
