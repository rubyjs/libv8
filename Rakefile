require 'bundler/setup'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

module Helpers
  module_function
  def get_binary_gemspec(platform = RUBY_PLATFORM)
    gemspec = eval(File.read('libv8.gemspec'))
    gemspec.platform = Gem::Platform.new(platform)
    gemspec
  end

  def binary_gem_name
    File.basename get_binary_gemspec.cache_file
  end
end

desc "compile v8 via the ruby extension mechanism"
task :compile do
  sh "ruby ext/libv8/extconf.rb"
end

desc "build a binary gem #{Helpers.binary_gem_name}"
task :binary => :compile do
  gemspec = Helpers.get_binary_gemspec
  gemspec.extensions.clear
  # We don't need most things for the binary
  gemspec.files = []
  gemspec.files += ['lib/libv8.rb', 'lib/libv8/version.rb']
  gemspec.files += ['ext/libv8/arch.rb', 'ext/libv8/location.rb', 'ext/libv8/paths.rb']
  gemspec.files += ['ext/libv8/.location.yml']
  # V8
  gemspec.files += Dir['vendor/v8/include/*']
  gemspec.files += Dir['vendor/v8/out/**/*.a']
  FileUtils.chmod 'a+r', gemspec.files
  FileUtils.mkdir_p 'pkg'
  package = if Gem::VERSION < '2.0.0'
    Gem::Builder.new(gemspec).build
  else
    require 'rubygems/package'
    Gem::Package.build(gemspec)
  end
  FileUtils.mv(package, 'pkg')
end

desc "clean up artifacts of the build"
task :clean do
  sh "rm -rf pkg"
  sh "git clean -df"
  sh "git submodule foreach git reset --hard"
  sh "git submodule foreach git clean -df"
end

task :default => [:compile, :spec]
task :build => [:clean]
