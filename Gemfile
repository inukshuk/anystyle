source 'https://rubygems.org'
gemspec

group :development, :test do
  #gem 'anystyle-data', github: 'inukshuk/anystyle-data'
  #gem 'wapiti', github: 'inukshuk/wapiti-ruby'
  gem 'rake'
  gem 'rspec'
  gem 'yaml'
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
	gem 'lmdb', platforms: :mri
  gem 'redis'
  gem 'redis-namespace'
  gem 'edtf'
  gem 'bibtex-ruby'
  gem 'citeproc'
  gem 'unicode-scripts'
  gem 'cld3'
end
