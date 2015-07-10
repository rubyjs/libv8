require 'bundler/setup'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new :spec

module Helpers
  module_function
  def binary_gemspec(platform = Gem::Platform.local)
    gemspec = eval(File.read 'libv8.gemspec')
    gemspec.platform = platform
    gemspec
  end

  def binary_gem_name(platform = Gem::Platform.local)
    File.basename binary_gemspec(platform).cache_file
  end
end

desc "compile v8 via the ruby extension mechanism"
task :compile  do
  sh "ruby ext/libv8/extconf.rb"
end

desc "build a binary gem #{Helpers.binary_gem_name}"
task :binary => :compile do
  gemspec = Helpers.binary_gemspec
  gemspec.extensions.clear

  # We don't need most things for the binary
  gemspec.files = []
  gemspec.files += ['lib/libv8.rb', 'lib/libv8/version.rb']
  gemspec.files += ['ext/libv8/arch.rb', 'ext/libv8/location.rb', 'ext/libv8/paths.rb']
  gemspec.files += ['ext/libv8/.location.yml']

  # V8
  gemspec.files += Dir['vendor/v8/include/**/*.h']
  gemspec.files += Dir['vendor/v8/out/**/*.a']

  FileUtils.chmod 0644, gemspec.files
  FileUtils.mkdir_p 'pkg'

  package = if Gem::VERSION < '2.0.0'
    Gem::Builder.new(gemspec).build
  else
    require 'rubygems/package'
    Gem::Package.build gemspec
  end

  FileUtils.mv package, 'pkg'
end

namespace :build do
  ['x86_64-linux', 'x86-linux'].each do |arch|
    desc "build binary gem for #{arch}"
    task arch do
      arch_dir = Pathname(__FILE__).dirname.join("release/#{arch}")
      Dir.chdir(arch_dir) do
        sh "vagrant up"
        sh "vagrant ssh -c 'rm -rf libv8 && git clone /libv8/.git libv8'"
        sh "vagrant ssh -c 'cd libv8 && git submodule update --init --depth=1'"
        sh "vagrant ssh -c 'cd libv8 && bundle install --path vendor/bundle'"
        sh "vagrant ssh -c 'cd libv8 && bundle exec rake binary'"
        sh "vagrant ssh -c 'cp libv8/pkg/*.gem /vagrant'"
      end
    end
  end
end

task :clean_submodules do
  sh "git submodule --quiet foreach git reset --hard"
  sh "git submodule --quiet foreach git clean -dxf"
  sh "git submodule update --init"
end

desc "clean up artifacts of the build"
task :clean => [:clean_submodules] do
  sh "rm -rf pkg"
  sh "rm -rf vendor/v8"
  sh "git clean -dxf -e .bundle -e vendor/bundle"
end

task :default => [:compile, :spec]
task :build => [:clean]
