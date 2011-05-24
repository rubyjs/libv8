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

desc "Compile the V8 JavaScript engine"
task "compile" do
  Dir.chdir(File.join('lib', 'libv8')) do
    puts "Compiling V8..."
    $stdout.flush
    `make`
  end
end