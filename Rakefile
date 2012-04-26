require 'bundler/setup'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

V8_Version = Libv8::VERSION.gsub(/\.\d$/,'')
V8_Source = File.expand_path '../vendor/v8', __FILE__

task :checkout do
  sh "git submodule update --init"
  Dir.chdir(V8_Source) do
    sh "git fetch"
    sh "git checkout #{V8_Version}"
  end
end

task :compile do
  Dir.chdir(V8_Source) do
    puts "compiling libv8"
    sh "make dependencies"
    sh "make native GYP_GENERATORS=make"
  end
end

"clean up artifacts of the build"
task :clean do
  sh "rm -rf pkg"
  sh "cd #{V8_Source} && rm -rf out"
end

task :default => [:compile, :spec]
