source 'https://rubygems.org'
gemspec

group :development, :test do
  gem 'rake'
  gem 'cucumber'
  gem 'rspec', '~>3.0'
  gem 'simplecov', :require => false
  gem 'coveralls', :require => false

  gem 'language_detector', github: 'feedbackmine/language_detector'
end

group :debug do
  gem 'byebug', :require => false
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

group :lmdb do
	gem 'lmdb'
end
