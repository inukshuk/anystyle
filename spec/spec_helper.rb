begin
  require 'simplecov'
  require 'coveralls' if ENV['CI']
rescue LoadError
  # ignore
end

begin
  case
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    require 'rubinius/debugger'
  when RUBY_VERSION < '2.0'
    require 'debugger'
  else
    require 'byebug'
  end
rescue LoadError
  # ignore
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'anystyle/parser'

module Fixtures
	PATH = File.expand_path('../fixtures', __FILE__)

	Dir[File.join(PATH, '*.rb')].each do |fixture|
		require fixture
	end

  def fixture_path(path)
    File.join(PATH, path)
  end
end

RSpec.configure do |config|
  config.include Fixtures

  def strip_tags(string)
    Anystyle.parser.send :decode_xml_text, string.gsub(/<[^>]+>/, '')
  end
end
