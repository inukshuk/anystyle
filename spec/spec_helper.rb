begin
  require 'simplecov'
rescue LoadError
  # ignore
end

begin
  require 'debug'
rescue LoadError
  # ignore
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'anystyle'
require 'yaml'

AnyStyle::Dictionary.defaults[:adapter] = :memory

module Fixtures
  PATH = File.expand_path('../fixtures', __FILE__)

	Dir[File.join(PATH, '*.rb')].each do |fixture|
		require fixture
	end

  CACHE = {}

  def fixture_path(path)
    File.join(PATH, path)
  end

  def fixture(path)
    CACHE[path] = load_fixture(path) unless CACHE.key?(path)
    CACHE[path]
  end

  def load_fixture(path)
    case File.extname(path)
    when '.yml'
      YAML.load(File.read(fixture_path(path)))
    else
      File.read(fixture_path(path))
    end
  end

  def names(key)
    fixture('names.yml')[key.to_s]
  end
end

module Resources
  PATH = File.expand_path('../../res', __FILE__)

  def resource(name = 'parser/core.xml', format: 'hash', **opts)
    AnyStyle::Parser.new.parse(
      Wapiti::Dataset.open(File.join(PATH, name)),
      format: format, **opts
    )
  end
end

RSpec.configure do |config|
  config.include Fixtures
  config.include Resources
end
