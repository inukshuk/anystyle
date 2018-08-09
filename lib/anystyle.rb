require 'forwardable'
require 'wapiti'

require 'anystyle/version'
require 'anystyle/support'
require 'anystyle/errors'
require 'anystyle/utils'
require 'anystyle/dictionary'
require 'anystyle/dictionary/marshal'
require 'anystyle/data'

require 'anystyle/feature'
require 'anystyle/feature/affix'
require 'anystyle/feature/brackets'
require 'anystyle/feature/canonical'
require 'anystyle/feature/caps'
require 'anystyle/feature/category'
require 'anystyle/feature/dictionary'
require 'anystyle/feature/indent'
require 'anystyle/feature/keyword'
require 'anystyle/feature/line'
require 'anystyle/feature/locator'
require 'anystyle/feature/number'
require 'anystyle/feature/position'
require 'anystyle/feature/punctuation'
require 'anystyle/feature/ref'
require 'anystyle/feature/terminal'
require 'anystyle/feature/words'

require 'anystyle/normalizer'
require 'anystyle/normalizer/brackets'
require 'anystyle/normalizer/container'
require 'anystyle/normalizer/date'
require 'anystyle/normalizer/edition'
require 'anystyle/normalizer/journal'
require 'anystyle/normalizer/locale'
require 'anystyle/normalizer/location'
require 'anystyle/normalizer/locator'
require 'anystyle/normalizer/names'
require 'anystyle/normalizer/page'
require 'anystyle/normalizer/publisher'
require 'anystyle/normalizer/pubmed'
require 'anystyle/normalizer/punctuation'
require 'anystyle/normalizer/quotes'
require 'anystyle/normalizer/type'
require 'anystyle/normalizer/unicode'
require 'anystyle/normalizer/volume'

require 'anystyle/format/bibtex'
require 'anystyle/format/csl'

require 'anystyle/page'
require 'anystyle/refs'
require 'anystyle/document'
require 'anystyle/parser'
require 'anystyle/finder'

module AnyStyle
  def self.parser
    Parser.instance
  end

  def self.parse(*arguments)
    parser.parse(*arguments)
  end

  def self.finder
    Finder.instance
  end

  def self.find(*arguments)
    finder.find(*arguments)
  end
end
