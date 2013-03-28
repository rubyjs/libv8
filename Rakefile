require 'bundler/setup'
Bundler::GemHelper.install_tasks
class Bundler::GemHelper
  def clean?
    sh_with_code('git diff --exit-code --ignore-submodules')[1] == 0
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

V8_Version = Libv8::VERSION.gsub(/\.\d+$/,'')
V8_Source = File.expand_path '../vendor/v8', __FILE__

require File.expand_path '../ext/libv8/make.rb', __FILE__
include Libv8::Make

desc "setup the vendored v8 source to correspond to the libv8 gem version and prepare deps"
task :checkout do
  sh "git submodule update --init"
  Dir.chdir(V8_Source) do
    sh "git fetch"
    sh "git checkout #{V8_Version} -f"
    sh "#{make} dependencies"
  end
end

desc "compile v8 via the ruby extension mechanism"
task :compile do
  sh "ruby ext/libv8/extconf.rb"
end


desc "manually invoke the GYP compile. Useful for seeing debug output"
task :manual_compile do
  require File.expand_path '../ext/libv8/arch.rb', __FILE__
  include Libv8::Arch
  Dir.chdir(V8_Source) do
    sh %Q{#{make} -j2 #{libv8_arch}.release ARFLAGS.target=crs}
  end
end

def default_platform
  require 'rbconfig'

  # Returning an array is necessary as Platform::new reduces strings as
  # 'arm-linux-gnueabihf' to 'arm-linux'
  if ENV['TARGET'] then ENV['TARGET'].split '-', 1
  else  RbConfig::CONFIG.values_at 'target_cpu', 'target_os'
  end
end

def get_binary_gemspec(platform = default_platform)
  gemspec = eval(File.read('libv8.gemspec'))
  gemspec.platform = Gem::Platform.new(platform)
  gemspec
end

begin
  binary_gem_name = File.basename get_binary_gemspec.cache_file
rescue
  binary_gem_name = ''
end

desc "build a binary gem #{binary_gem_name}"
task :binary => :compile do
  gemspec = get_binary_gemspec
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
  sh "cd #{V8_Source} && git checkout -f && git clean -dxf"
end

desc "build a binary on heroku (you must have vulcan configured for this)"
task :vulcan => directory("tmp/vulcan") do
  Dir.chdir('tmp/vulcan') do
    sh "vulcan build -v -c 'LANG=en_US.UTF-8 export BIN=/`pwd`/bin && export GEM=$BIN/gem && curl https://s3.amazonaws.com/heroku-buildpack-ruby/ruby-1.9.3.tgz > ruby-1.9.3.tgz && tar xf ruby-1.9.3.tgz && cd /tmp && $GEM fetch libv8 --platform=ruby --version=#{Libv8::VERSION} && $GEM unpack libv8*.gem && $GEM install bundler -n $BIN --no-ri --no-rdoc && cd libv8-#{Libv8::VERSION} && $BIN/bundle && $BIN/bundle exec rake binary' -p /tmp/libv8-#{Libv8::VERSION}"
  end
end

task :default => [:checkout, :compile, :spec]
task :build => [:clean, :checkout]
