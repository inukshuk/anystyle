source 'https://rubygems.org'

gem 'anystyle-cli', git: 'https://github.com/ColourBlindHobbiest/anystyle-cli.git'

gemspec

group :development, :test do
  #gem 'anystyle-data', github: 'inukshuk/anystyle-data'
  #gem 'wapiti', github: 'inukshuk/wapiti-ruby'
  gem 'rake'
  gem 'rspec'
end

group :coverage do
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
end

group :debug do
  gem 'debug', '>= 1.0.0', require: false
end

group :profile do
	gem 'ruby-prof', require: false
	gem 'gnuplot', require: false
end

group :extra do
	gem 'lmdb'
  gem 'redis'
  gem 'redis-namespace'
  gem 'edtf'
  gem 'bibtex-ruby'
  gem 'citeproc'
  gem 'unicode-scripts'
  gem 'cld3'
end
