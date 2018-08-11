source 'https://rubygems.org'
gemspec


group :development, :test do
  #gem 'anystyle-data', github: 'inukshuk/anystyle-data'
  #gem 'wapiti', github: 'inukshuk/wapiti-ruby'
  gem 'bibtex-ruby'
  gem 'rake'
  gem 'rspec', '~>3.0'
  gem 'language_detector', github: 'feedbackmine/language_detector'
  gem 'unicode-scripts'
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
