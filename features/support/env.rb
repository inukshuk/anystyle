begin
  require 'simplecov'
  require 'coveralls' if ENV['CI']
rescue LoadError
  # ignore
end

begin
  case
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    require 'rubinius/debugger'
  when RUBY_VERSION < '2.0'
    require 'debugger'
  else
    require 'byebug'
  end
rescue LoadError
  # ignore
end

require 'anystyle/parser'
