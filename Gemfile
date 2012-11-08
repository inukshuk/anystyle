source 'https://rubygems.org'
gemspec

group :development do
	gem 'debugger', :platforms => [:mri_19]	
	gem 'simplecov'
	gem 'yard'
end

group :test  do
	gem 'rake'
	gem 'racc', '~>1.4'

	gem 'cucumber'
	gem 'rspec'
	gem 'ZenTest'
end

group :profile do
	gem 'ruby-prof'
	gem 'gnuplot'
end

group :extra do
	gem 'kyotocabinet-ruby', :require => 'kyotocabinet'
	gem 'autotest-fsevent', :require => false  
end
