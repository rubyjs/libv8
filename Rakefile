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

  # Fix gyp trying to build platform-linux on FreeBSD 9 and FreeBSD 10.
  # Based on: https://chromiumcodereview.appspot.com/10079030/patch/1/2
  sh "patch -N -p0 -d vendor/v8 < patches/add-freebsd9-and-freebsd10-to-gyp-GetFlavor.patch"
  sh "patch -N -p1 -d vendor/v8 < patches/fPIC-on-x64.patch"
  sh "patch -N -p1 -d vendor/v8 < patches/do-not-imply-vfp3-and-armv7.patch"
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

def get_binary_gemspec(platform = RUBY_PLATFORM)
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
  package = Gem::VERSION < '2.0.0' ? Gem::Builder.new(gemspec).build : Gem::Package.build(gemspec)
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
