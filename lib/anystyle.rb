require 'forwardable'
require 'wapiti'

require 'anystyle/version'
require 'anystyle/support'
require 'anystyle/errors'
require 'anystyle/utils'
require 'anystyle/dictionary'
require 'anystyle/dictionary/gdbm'
require 'anystyle/data'

require 'anystyle/feature'
require 'anystyle/feature/affix'
require 'anystyle/feature/canonical'
require 'anystyle/feature/caps'
require 'anystyle/feature/category'
require 'anystyle/feature/dictionary'
require 'anystyle/feature/keyword'
require 'anystyle/feature/locator'
require 'anystyle/feature/number'
require 'anystyle/feature/position'
require 'anystyle/feature/punctuation'

require 'anystyle/normalizer'
require 'anystyle/normalizer/container'
require 'anystyle/normalizer/date'
require 'anystyle/normalizer/locale'
require 'anystyle/normalizer/location'
require 'anystyle/normalizer/locator'
require 'anystyle/normalizer/names'
require 'anystyle/normalizer/page'
require 'anystyle/normalizer/punctuation'
require 'anystyle/normalizer/quotes'
require 'anystyle/normalizer/type'
require 'anystyle/normalizer/volume'

require 'anystyle/parser'

module AnyStyle
  def self.parser
    Parser.instance
  end

  def self.parse(*arguments)
    parser.parse(*arguments)
  end
end
