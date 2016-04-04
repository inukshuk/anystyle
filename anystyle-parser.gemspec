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
  s.homepage    = 'http://anystyle.io'
  s.summary     = 'Smart and fast academic bibliography parser.'
  s.description = 'A sophisticated parser for academic reference lists and bibliographies based on machine learning algorithms using conditional random fields.'
  s.license     = 'BSD-2-Clause-FreeBSD'

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency('bibtex-ruby', '~>4.0')
  s.add_runtime_dependency('builder', '>=3.0', '<4.0')
  s.add_runtime_dependency('wapiti', '~>0.1')
  s.add_runtime_dependency('namae', '~>0.9')

  s.files        = `git ls-files`.split("\n").reject { |path|
    path.start_with?('.')
  } - Dir['resources/**/*']

  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.rdoc_options      = %w{--line-numbers --inline-source --title "Anystyle\ Parser" --main README.md}
  s.extra_rdoc_files  = %w{README.md LICENSE}

end

# vim: syntax=ruby
