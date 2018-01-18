source 'https://rubygems.org'
gemspec

gem 'anystyle-data', github: 'inukshuk/anystyle-data'

group :development, :test do
  gem 'wapiti', github: 'inukshuk/wapiti-ruby'
  gem 'rake'
  gem 'rspec', '~>3.0'
  gem 'language_detector', github: 'feedbackmine/language_detector'
end

group :coverage do
  gem 'simplecov', require: false
  gem 'coveralls', require: false if ENV['CI']
end

group :debug do
  gem 'byebug', require: false
end

group :profile do
	gem 'ruby-prof', require: false
	gem 'gnuplot', require: false
end

group :extra do
	gem 'lmdb'
  gem 'redis'
  gem 'redis-namespace'
  gem 'yard'
end
