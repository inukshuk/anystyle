module AnyStyle
  class Normalizer
    class Quotes < Normalizer
      QUOTES = /^[«‹»›„‚“‟‘‛”’"❛❜❟❝❞⹂〝〞〟\[]|[«‹»›„‚“‟‘‛”’"❛❜❟❝❞⹂〝〞〟\]]$/
      @keys = [:title, :'citation-number', :medium]

      def normalize(item)
        each_value(item) do |_, value|
          value.gsub! QUOTES, ''
        end
      end
    end
  end
end
