# This is a sanity check to enforce that the v8 submodule is initialized
# before we try to run any rake tasks.
if !File.exist? File.join('lib', 'libv8', 'v8', 'SConstruct') then
  puts "V8 source appears to be missing. Updating..."
  `git submodule update --init`
end

# Now we include the bundler stuff...
# We had to do the fetch first since our version code requires that we have
# the V8 source

require 'bundler'
require 'bundler/setup'

Bundler::GemHelper.install_tasks

# desc "remove all generated artifacts except built v8 objects"
# task :clean do
#   sh "rm -rf pkg"
#   sh "rm -rf ext/v8/Makefile"
#   sh "rm -rf ext/v8/*.bundle ext/v8/*.so"
#   sh "rm -rf lib/v8/*.bundle lib/v8/*.so"
# end
# 
# desc "build v8 with debugging symbols (much slower)"
# task "v8:debug" do
#   sh "cd ext/v8/upstream && make debug"
# end

# Rake::ExtensionTask.new("libv8", eval(File.read("libv8.gemspec"))) do |ext|
#   ext.lib_dir = "lib/libv8"
# end

latest_v8 = nil
Dir.chdir(File.join('lib', 'libv8', 'v8')) do
  latest_v8 = `git tag`.split.map{|v| Gem::Version.new(v)}.sort.last.to_s
end

desc "Check out a version of V8"
task :checkout, :version do |t, options|
  options.with_defaults(:version => latest_v8)
  Dir.chdir(File.join('lib', 'libv8', 'v8')) do
    `git fetch`
    # We're checking out the latest tag. Sorted using Gem::Version
    versions = `git tag`.split.map{|v| Gem::Version.new(v)}.sort
    fail "Version #{options.version} does not exist! Aborting..." if !versions.member?(Gem::Version.new(options.version))
    puts "Checking out version #{options.version}"
    `git checkout -f tags/#{options.version}`
    File.open(File.join(File.dirname(__FILE__), 'lib', 'libv8', 'VERSION'), 'w') { |f| f.write options.version.to_s }
  end
end

desc "Compile the V8 JavaScript engine"
task :compile, [:version] do |t, options|
  options.with_defaults(:version => latest_v8)
  
  begin
    def crash(str)
      printf("Unable to build libv8: %s\n", str)
      exit 1
    end
    
    print "Checking for Python..."
    version = `python --version 2>&1`
    version_number = version.split.last.match("[0-9.]+")[0]
    crash "Python not found!" if version.split.first != "Python"
    crash "Python 3.x is unsupported by V8!" if 
				Gem::Version.new(version_number) >= 
				Gem::Version.new(3)
    crash "Python 2.4+ is required by V8!" if Gem::Version.new(version_number) < Gem::Version.new("2.4")
    puts version_number
  end
  
  puts "Compiling V8 (#{options.version})..."
  Rake::Task[:checkout].invoke(options.version)
  Dir.chdir(File.join('lib', 'libv8')) do
    `make`
  end
end

desc "Clean up from the build"
task :clean do |t, options|
  Dir.chdir(File.join('lib', 'libv8')) do
    `make clean`
  end
end

desc "List all versions of V8"
task :list do
  Dir.chdir(File.join('lib', 'libv8', 'v8')) do
    puts `git tag`.split.map{|v| Gem::Version.new(v)}.sort
  end
end  

desc "Create a binary gem for this current platform"
task :binary, [:version] => [:compile] do |t, options|
  gemspec = eval(File.read('libv8.gemspec'))
  gemspec.extensions.clear
  gemspec.platform = Gem::Platform.new(RUBY_PLATFORM)

  # We don't need most things for the binary
  gemspec.files = []
  # Lib
  gemspec.files << 'lib/libv8.rb'
  gemspec.files << 'lib/libv8/version.rb'
  # V8
  Dir.glob('lib/libv8/v8/include/*').each { |f| gemspec.files << f }
  gemspec.files << "lib/libv8/build/v8/libv8.a"
  gemspec.files << "lib/libv8/build/v8/libv8preparser.a"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv(Gem::Builder.new(gemspec).build, 'pkg')
end

task :default => :binary
