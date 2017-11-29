module AnyStyle
  module Utils
    def maybe_require(mod)
      require mod
      yield if block_given?
    rescue LoadError
      # ignore
    end

    def transliterate(string)
      string.unicode_normalize(:nfd).gsub(/\p{Mark}/, '')
    end
  end

  extend Utils
end
