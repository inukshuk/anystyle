module AnyStyle
  class Normalizer
    class ArXiv < Normalizer
      @keys = [:note]

      def normalize(item, **opts)
        each_value(item) do |_, value|
          if (value =~ /arxiv:?\s*(\d{4}\.\d+(?:v\d+)?|\w+(?:.\w+)?\/\d+)/i)
            append item, :arxiv, $1
          end
        end
      end
    end
  end
end
