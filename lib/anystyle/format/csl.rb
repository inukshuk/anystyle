module AnyStyle
  module Format
    module CSL
      def format_csl(dataset)
        format_bibtex(dataset).to_citeproc
      end

      alias_method :format_citeproc, :format_csl
    end
  end
end
