# -*- encoding: utf-8 -*-
require 'pathname'

$:.push File.expand_path("../lib", __FILE__)
require "libv8/version"

Gem::Specification.new do |s|
  s.name        = "libv8"
  s.version     = Libv8::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Logan Lowell", "Charles Lowell"]
  s.email       = ["fractaloop@thefrontside.net", "cowboyd@thefrontside.net"]
  s.homepage    = "http://github.com/fractaloop/libv8"
  s.summary     = %q{Distribution of the V8 JavaScript engine}
  s.description = %q{Distributes the V8 JavaScript engine in binary and source forms in order to support fast builds of The Ruby Racer}

  s.rubyforge_project = "libv8"

  root = Pathname(__FILE__).dirname
  s.files         = `git ls-files`.split("\n")
  s.files += Dir.chdir(root.join("lib/libv8/v8")) do
    `git ls-files`.split("\n").reject {|f| f =~ /^test/ || f =~ /^samples/ || f =~ /^benchmarks/}.map {|f| "lib/libv8/v8/#{f}"}
  end
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extensions = ["ext/libv8/extconf.rb"]
  # s.require_paths = ["lib", "ext"]
  s.require_paths = ["lib"]
  
  s.add_dependency "rake"
  s.add_development_dependency "bundler"
  # s.add_development_dependency "rake-compiler"
  
end
