require 'bundler/setup'
require 'rspec/core/rake_task'
require 'tmpdir'

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
  gemspec.files += ['ext/libv8/location.rb', 'ext/libv8/paths.rb']
  gemspec.files += ['ext/libv8/.location.yml']

  # V8
  gemspec.files += Dir['vendor/v8/include/**/*.h']
  gemspec.files += Dir['vendor/v8/out.gn/**/*.a']

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

task :repack, [:gemfile, :new_arch] do |t, args|
  dir = Dir::mktmpdir

  begin
    sh "gem unpack #{args[:gemfile]} --target=#{dir}"
    sh "gem spec #{args[:gemfile]} --ruby > #{dir}/repack.gemspec"
    Dir.chdir(dir) do
      sh "sed -i 's/^  s.platform = .*$/  s.platform = \"#{args[:new_arch]}\".freeze/' repack.gemspec"
      Dir.chdir(Dir.glob("libv8-*/").first) do
        sh 'gem build ../repack.gemspec'
      end
    end

    sh "mv #{dir}/*/*.gem ./pkg/"
  ensure
    FileUtils.remove_entry_secure dir
  end
end
