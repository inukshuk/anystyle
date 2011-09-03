source :rubygems
gemspec

group :debug do
	gem 'ruby-debug19', :require => 'ruby-debug', :platforms => [:mri_19]
	gem 'ruby-debug', :platforms => [:mri_18, :jruby]
	gem 'rbx-trepanning', :platforms => [:rbx]
end

group :osx_test do
	gem 'autotest-fsevent', :require => false  
end

group :profile do
	gem 'ruby-prof'
	gem 'gnuplot'
end

group :kyotocabinet do
	gem 'kyotocabinet-ruby', :require => 'kyotocabinet'
end