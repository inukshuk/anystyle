module AnyStyle
  class Normalizer
    class Unicode < Normalizer
      @keys = [
        :'collection-title',
        :'container-title',
        :author,
        :date,
        :director,
        :doi,
        :edition,
        :editor,
        :genre,
        :isbn,
        :journal,
        :location,
        :medium,
        :note,
        :pages,
        :producer,
        :publisher,
        :title,
        :translator,
        :url,
        :volume
      ]

      attr_accessor :form

      def initialize(form: :nfkc)
        super()
        @form = form
      end

      def normalize(item, **opts)
        map_values(item) do |_, value|
          value.unicode_normalize(form)
        end
      end
    end
  end
end
