source 'https://rubygems.org'
gemspec

group :development, :test do
  gem 'rake'
  gem 'cucumber'
  gem 'rspec', '~>3.0'
  gem 'simplecov', '~>0.8', :require => false
  gem 'rubinius-coverage', :platform => :rbx
  gem 'coveralls', :require => false

  gem 'language_detector', github: 'feedbackmine/language_detector'
end

group :debug do
  if RUBY_VERSION >= '2.0'
    gem 'byebug', :require => false, :platforms => :mri
  else
    gem 'debugger', :require => false, :platforms => :mri
  end

  gem 'ruby-debug', :require => false, :platforms => :jruby

  gem 'rubinius-compiler', '~>2.0', :require => false, :platform => :rbx
  gem 'rubinius-debugger', '~>2.0', :require => false, :platform => :rbx
end

group :profile do
	gem 'ruby-prof', :require => false, :platform => :mri
	gem 'gnuplot', :require => false, :platform => :mri
end

group :extra do
	gem 'autotest-fsevent', :require => false
  gem 'yard'
	gem 'ZenTest'
end

group :redis do
  gem 'redis'
  gem 'hiredis'
  gem 'redis-namespace'
end

group :kyoto do
	gem 'kyotocabinet-ruby', :require => 'kyotocabinet'
end

platform :rbx do
  gem 'rubysl', '~>2.0'
  gem 'json', '~>1.8'
  gem 'racc'
end
