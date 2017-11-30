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

require 'anystyle/version'

task :default
task :build => [:clean] do
  system 'gem build anystyle-parser.gemspec'
end

task :release => [:build] do
  system "git tag #{AnyStyle::VERSION}"
  system "gem push anystyle-parser-#{AnyStyle::VERSION}.gem"
end

task :check_warnings do
  $VERBOSE = true
  require 'anystyle/parser'

  puts AnyStyle::VERSION
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :test_with_coveralls => [:spec, 'coveralls:push']
rescue LoadError
  # ignore
end if ENV['CI']

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  # ignore
end

desc 'Run an IRB session with AnyStyle loaded'
task :console, [:script] do |t, args|
  ARGV.clear

  require 'irb'
  require 'anystyle'

  IRB.conf[:SCRIPT] = args.script
  IRB.start
end

CLEAN.include('*.gem')
CLEAN.include('*.rbc')
