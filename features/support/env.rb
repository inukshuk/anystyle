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
  else
    require 'debugger'
  end
rescue LoadError
  # ignore
end

require 'anystyle/parser'
