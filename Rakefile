require 'bundler/setup'
require 'rspec/core/rake_task'
require 'tmpdir'
require 'rubygems/package'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new :spec

DISTRIBUTIONS = [
  'x86_64-linux',
  'x86-linux',
  'x86_64-freebsd-10',
  'x86_64-freebsd-11',
  'amd64-freebsd-10',
  'amd64-freebsd-11',
  'arm-linux',
  'aarch64-linux',
  # 'x86_64-linux-musl'
]

module Helpers
  module_function
  def binary_gemspec(platform = Gem::Platform.local)
    eval(File.read 'libv8.gemspec').tap do |gemspec|
      gemspec.platform = platform
      gemspec.extensions.clear

      # We don't need most things for the binary
      gemspec.files = []
      gemspec.files += ['lib/libv8.rb', 'lib/libv8/version.rb']
      gemspec.files += ['ext/libv8/location.rb', 'ext/libv8/paths.rb']
      gemspec.files += ['ext/libv8/.location.yml']

      # V8
      gemspec.files += Dir['vendor/v8/include/**/*.h']
      gemspec.files += Dir['vendor/v8/out.gn/**/*.a']
    end
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

  FileUtils.chmod 0644, gemspec.files
  FileUtils.mkdir_p 'pkg'

  package = Gem::Package.build gemspec
  FileUtils.mv package, 'pkg'
end

namespace :build do
  DISTRIBUTIONS.each do |arch|
    desc "build binary gem for #{arch}"
    task arch do
      arch_dir = Pathname(__FILE__).dirname.join("release/#{arch}")
      Dir.chdir(arch_dir) do
        ENV['RUBYLIB'] = nil # https://github.com/mitchellh/vagrant/issues/6158
        sh "vagrant up"
        sh "vagrant ssh -c 'rm -rf ~/libv8'"
        sh "vagrant ssh -c 'git clone /libv8/.git ~/libv8 --recursive'"
        sh "vagrant ssh -c 'cd ~/libv8 && bundle install --path vendor/bundle'"
        sh "vagrant ssh -c 'cd ~/libv8 && env MAKEFLAGS=-j4 bundle exec rake binary'"
        sh "vagrant status | grep scaleway" do |ok, res|
          if ok
            sh "vagrant ssh --no-tty -c 'cd ~/libv8/pkg && tar -cf - *.gem' 2>/dev/null | tar -xv"
          else
            sh "vagrant ssh -c 'cp ~/libv8/pkg/*.gem /vagrant'"
          end
        end
        sh "vagrant destroy -f"
      end
    end
  end
end

desc "Build binary gems for all supported distributions"
task :binary_release => [:build] + DISTRIBUTIONS.map {|distribution| "build:#{distribution}"} do
  sh "cd #{File.dirname(__FILE__)} && mkdir -p pkg"
  sh "cd #{File.dirname(__FILE__)} && mv release/**/*.gem pkg/"
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

desc 'Generate OSX platform builds. Although any v8 OSX compile will run on any Mac OS version down to 10.10, RubyGems requires us to submit all of the different platforms seperately. Requires `compile` to already have been run, but is seperate for Travis reasons.'
task :osx_varients do
  gemspec = Helpers.binary_gemspec
  next unless Gem::Platform.local.os == 'darwin'

  [15, 16, 17, 18, 19].each do |version|
    %w(x86_64 universal).each do |cpu|

      gemspec.platform = Gem::Platform.local.tap do |platform|
        platform.cpu = cpu
        platform.version = version
      end

      package = Gem::Package.build gemspec
      FileUtils.mv package, 'pkg'
    end
  end
end

desc 'Push a release from github'
task :push_github_release do

  releases = (15..19).map do |i|
    ["-universal-darwin-#{i}", "-x86_64-darwin-#{i}"]
  end.flatten

  releases << ""
  releases << "-x86_64-linux"

  FileUtils.mkdir_p("pkg")

  Dir.chdir("pkg") do
    releases.each do |release|
      cmd = "wget https://github.com/rubyjs/libv8/releases/download/v#{Libv8::VERSION}/libv8-#{Libv8::VERSION}#{release}.gem"
      puts cmd
      puts `#{cmd}`
    end

    otp = 111111
    Dir["*#{Libv8::VERSION}*.gem"].each do |f|
      puts "pushing #{f}"
      begin
        result = `gem push #{f} --otp #{otp}`
        if result =~ /OTP code is incorrect/
          puts "enter otp"
          otp = STDIN.gets.strip
          redo
        end
      end
      puts result
    end
  end
end
