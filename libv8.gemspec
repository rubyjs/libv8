$:.unshift File.expand_path("../lib", __FILE__)
require "libv8/version"

Gem::Specification.new do |s|
  s.name        = "libv8"
  s.version     = Libv8::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Charles Lowell"]
  s.email       = ["cowboyd@thefrontside.net"]
  s.homepage    = "http://github.com/cowboyd/libv8"
  s.summary     = %q{Distribution of the V8 JavaScript engine}
  s.description = %q{Distributes the V8 JavaScript engine in binary and source forms in order to support fast builds of The Ruby Racer}
  s.license     = "MIT"

  s.rubyforge_project = "libv8"

  s.files  = `git ls-files`.split("\n").reject {|f| f =~ /^release\//}

  submodules = `git submodule --quiet foreach 'echo $path'`.split("\n").map(&:chomp)
  submodules.each do |submodule|
    s.files += Dir.chdir(submodule) do
      `git ls-files`.split("\n").reject {|f| f =~ /^test/}.map {|f| "#{submodule}/#{f}"}
    end
  end

  s.extensions = ["ext/libv8/extconf.rb"]
  s.require_paths = ["lib", "ext"]

  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'rake-compiler', '~> 0'
  s.add_development_dependency 'rspec', '~> 3'
end
