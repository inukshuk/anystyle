# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'anystyle/version'

Gem::Specification.new do |s|
  s.name        = 'anystyle-parser'
  s.version     = AnyStyle::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = ['http://sylvester.keil.or.at']
  s.homepage    = 'http://anystyle.io'
  s.summary     = 'Smart and fast bibliography parser.'
  s.description = 'A sophisticated parser for academic reference lists and bibliographies based on machine learning algorithms using conditional random fields.'
  s.license     = 'BSD-2-Clause'

  s.required_ruby_version = '>= 2.2'

  s.add_runtime_dependency('bibtex-ruby', '~>4.0')
  #s.add_runtime_dependency('wapiti', '~>1.0')
  s.add_runtime_dependency('namae', '~>1.0')

  s.files        = `git ls-files`.split("\n").reject { |path|
    path.start_with?('.')
  } - Dir['res/**/*']

  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.rdoc_options      = %w{--line-numbers --inline-source --title "AnyStyle\ Parser" --main README.md}
  s.extra_rdoc_files  = %w{README.md LICENSE}

end

# vim: syntax=ruby
