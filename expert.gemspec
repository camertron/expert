$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'expert/version'

Gem::Specification.new do |s|
  s.name     = 'expert'
  s.version  = ::Expert::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron'

  s.description = s.summary = 'Manage and install jar dependencies (an alternative to jbundler).'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.require_path = 'lib'
  s.executables << 'expert'
  s.files = Dir['{lib,spec,vendor}/**/*', 'Gemfile', 'History.txt', 'README.md', 'Rakefile', 'expert.gemspec']
end
