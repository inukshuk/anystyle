lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rake/clean'

require 'anystyle/parser/version'

task :build => [:clean] do
  system 'gem build anystyle-parser.gemspec'
end

task :release => [:build] do
  system "git tag #{Anystyle::Parser::VERSION}"
  system "gem push anystyle-parser-#{Anystyle::Parser::VERSION}.gem"
end

CLEAN.include('*.gem')
CLEAN.include('*.rbc')
