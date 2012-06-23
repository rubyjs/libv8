require 'mkmf'
create_makefile('libv8')
require File.expand_path '../arch.rb', __FILE__
require File.expand_path '../make.rb', __FILE__
require File.expand_path '../compiler.rb', __FILE__

include Libv8::Arch
include Libv8::Make
include Libv8::Compiler

Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
  puts `env CXX=#{File.basename compiler} LINK=#{File.basename compiler} #{File.basename make} #{libv8_arch}.release GYPFLAGS="-Dhost_arch=#{libv8_arch}"`
end

if $?.exitstatus != 0
  exit $?.exitstatus
end

begin
  require File.expand_path '../../../lib/libv8', __FILE__
  Libv8.libv8_objects
rescue => e
  puts e.message
  exit 1
end
