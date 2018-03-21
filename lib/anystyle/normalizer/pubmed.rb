module AnyStyle
  class Normalizer
    class PubMed < Normalizer
      @keys = [:note]

      def normalize(item)
        each_value(note) do |_, value|
          if (value =~ /PMID:?\s*(\d+)/)
            append :pmid, $1
          end
          if (value =~ /PMC(\d+)/)
            append :pmcid, $1
          end
        end
      end
    end
  end
end
