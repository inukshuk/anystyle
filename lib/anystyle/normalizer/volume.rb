module AnyStyle
  class Normalizer
    class Volume < Normalizer
      @keys = [:volume, :pages]

      def normalize(item)
        # TODO
        #if !hash.has_key?(:pages) && volume =~ /\D*(\d+):(\d+(?:[—–-]+)\d+)/
        #  hash[:volume], hash[:pages] = $1.to_i, $2
        #  hash = normalize_pages(hash)
        #else
        #  case volume
        #  when /\D*(\d+)\D+(\d+[\s\/&—–-]+\d+)/
        #    hash[:volume], hash[:number] = $1.to_i, $2
        #  when /(\d+)?\D+no\.\s*(\d+\D+\d+)/
        #    hash[:volume] = $1.to_i unless $1.nil?
        #    hash[:number] = $2
        #  when /(\d+)?\D+no\.\s*(\d+)/
        #    hash[:volume] = $1.to_i unless $1.nil?
        #    hash[:number] = $2.to_i
        #  when /\D*(\d+)\D+(\d+)/
        #    hash[:volume], hash[:number] = $1.to_i, $2.to_i
        #  when /(\d+)/
        #    hash[:volume] = $1.to_i
        #  end
        #end
      end
    end
  end
end
