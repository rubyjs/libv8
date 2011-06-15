require 'bundler'
require 'bundler/setup'

# require "rake/extensiontask"

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

desc "Get the latest source"
task :src_check do
  if File.exist? File.join('lib', 'libv8', 'v8', 'SConstruct') then
    Dir.chdir(File.join('lib', 'libv8', 'v8')) do
      `git checkout -f tags/#{`git tag`.split.sort.last}`
    end
  else
    puts "V8 source is missing. Did you initialize and update the submodule?"
    puts "\tTry: git submodule update --init"
    fail "Unable to find V8 source!"
  end
end

desc "Compile the V8 JavaScript engine"
task :compile => :src_check do
  puts "Compiling V8..."
  Dir.chdir(File.join('lib', 'libv8')) do
    `make`
  end
end

desc "Clean up from the build"
task :clean do
  Dir.chdir(File.join('lib', 'libv8')) do
    `make clean`
  end
end

desc "Create a binary gem for this current platform"
task :binary => :compile do
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