module AnyStyle
  class Normalizer
    class PubMed < Normalizer
      @keys = [:note]

      def normalize(item, **opts)
        each_value(item) do |_, value|
          if (value =~ /PMID:?\s*(\d+)/)
            append item, :pmid, $1
          end
          if (value =~ /PMC(\d+)/)
            append item, :pmcid, $1
          end
        end
      end
    end
  end
end
