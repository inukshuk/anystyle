module AnyStyle
  class Normalizer
    class Legacy < Normalizer
      @keys = [:medium]

      def normalize(item)
        map_values(item) do |label, value|
          case label
          when :medium
            value.split(/\W+/).reject(&:empty?).join('-')
          else
            value
          end
        end
      end
    end
  end
end
