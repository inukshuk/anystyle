require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'rake/clean'

$:.unshift(File.join(File.dirname(__FILE__), './lib'))

require 'anystyle/parser/version'

task :default
task :build => [:clean] do
  system 'gem build anystyle-parser.gemspec'
end

task :release => [:build] do
  system "git tag #{Anystyle::Parser::VERSION}"
  system "gem push anystyle-parser-#{Anystyle::Parser::VERSION}.gem"
end

task :check_warnings do
  $VERBOSE = true
  require 'anystyle/parser'

  puts Anystyle::Parser::VERSION
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :test_with_coveralls => [:spec, 'coveralls:push']

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  # ignore
end

desc 'Run an IRB session with Anystyle-Parser loaded'
task :console, [:script] do |t, args|
  ARGV.clear

  require 'irb'
  require 'anystyle/parser'

  IRB.conf[:SCRIPT] = args.script
  IRB.start
end

CLEAN.include('*.gem')
CLEAN.include('*.rbc')
