require 'bundler/setup'
Bundler::GemHelper.install_tasks
class Bundler::GemHelper
  def clean?
    sh_with_code('git diff --exit-code --ignore-submodules')[1] == 0
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

V8_Version = Libv8::VERSION.gsub(/\.\d$/,'')
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
  sh "patch -N -p1 -d vendor/v8 < patches/fPIC-on-linux-x64.patch"
end

desc "compile v8 via the ruby extension mechanism"
task :compile do
  sh "ruby ext/libv8/extconf.rb"
end

task :cross_compile do
  sh "patch -N -p0 -d vendor/v8 < patches/scons_crossmingw.patch"
  Dir.chdir(V8_Source) do
    sh "scons os=win32 toolchain=crossmingw library=shared"
  end
end

desc "manually invoke the GYP compile. Useful for seeing debug output"
task :manual_compile do
  require File.expand_path '../ext/libv8/arch.rb', __FILE__
  include Libv8::Arch
  Dir.chdir(V8_Source) do
    sh %Q{#{make} -j2 #{libv8_arch}.release GYPFLAGS="-Dhost_arch=#{libv8_arch}"}
  end
end

GEMSPEC_NAME = 'libv8.gemspec'
WIN_PLATFORM = 'i386-mingw32'

begin
  GEMSPEC = eval(File.read(GEMSPEC_NAME))

  desc "build all binary gems"
  task :binary

  def binary_task(platform, dep)
    gemspec = GEMSPEC.dup
    gemspec.platform = Gem::Platform.new(platform)
    # binary_gem_name = File.basename gemspec.cache_file  
    # desc "build a binary gem #{binary_gem_name}"
    task "binary:#{platform}" => dep do
      gemspec.extensions.clear
      # We don't need most things for the binary
      gemspec.files = ['lib/libv8.rb', 'ext/libv8/arch.rb', 'lib/libv8/version.rb']
      # V8
      gemspec.files += Dir['vendor/v8/include/*']
      gemspec.files += Dir['vendor/v8/out/**/*.a']
      # SCons build
      gemspec.files += Dir['vendor/v8/libv8.a']
      gemspec.files += Dir['vendor/v8/v8.dll']
      FileUtils.mkdir_p 'pkg'
      FileUtils.mv(Gem::Builder.new(gemspec).build, 'pkg')
    end
    Rake::Task[:binary].prerequisites << "binary:#{platform}"
  end

  binary_task(RUBY_PLATFORM, :compile)
  binary_task(WIN_PLATFORM,  :cross_compile) unless RUBY_PLATFORM =~ /mingw|mswin/
rescue SyntaxError
  puts "There is syntax error in #{GEMSPEC_NAME}"
end

desc "clean up artifacts of the build"
task :clean do
  sh "rm -rf pkg"
  sh "git clean -df"
  sh "cd #{V8_Source} && git clean -dxf"
end

task :default => [:checkout, :compile, :spec]
task :build => [:clean, :checkout]
