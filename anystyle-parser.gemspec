# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'anystyle/parser/version'

Gem::Specification.new do |s|
  s.name        = 'anystyle-parser'
  s.version     = Anystyle::Parser::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = ['http://sylvester.keil.or.at']
  s.homepage    = 'http://github.com/inukshuk/anystyle-parser'
  s.summary     = 'Parser for academic references.'
  s.description = 'A sophisticated parser for academic references based on machine learning algorithms using conditional random fields.'
  s.license     = 'FreeBSD'
  
  s.add_runtime_dependency('bibtex-ruby', '~>2.0')
  s.add_runtime_dependency('wapiti', '~>0.0')
  s.add_runtime_dependency('namae', '~>0.5')

  s.files        = `git ls-files`.split("\n") - Dir['resources/**/*']
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.rdoc_options      = %w{--line-numbers --inline-source --title "Anystyle\ Parser" --main README.md}
  s.extra_rdoc_files  = %w{README.md LICENSE}
  
end

# vim: syntax=ruby