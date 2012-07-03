require File.expand_path '../../../lib/libv8', __FILE__

if Libv8.mingw?
  File.open('Makefile', 'w'){|f| f.puts "all:\n\ninstall:\n" }
else  
  require 'mkmf'
  create_makefile('libv8')
  require File.expand_path '../arch.rb', __FILE__
  require File.expand_path '../make.rb', __FILE__
  require File.expand_path '../compiler.rb', __FILE__

  include Libv8::Arch
  include Libv8::Make
  include Libv8::Compiler
end

Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
  if Libv8.mingw?
    puts `scons os=win32 toolchain=gcc library=shared`
  else
    puts `env CXX=#{compiler} LINK=#{compiler} #{make} #{libv8_arch}.release GYPFLAGS="-Dhost_arch=#{libv8_arch}"`
  end
end

if $?.exitstatus != 0
  exit $?.exitstatus
end

begin
  Libv8.libv8_objects
rescue => e
  puts e.message
  exit 1
end
exit $?.exitstatus
