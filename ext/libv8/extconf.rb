require 'mkmf'
create_makefile('libv8')
require File.expand_path '../arch.rb', __FILE__
require File.expand_path '../make.rb', __FILE__
require File.expand_path '../compiler.rb', __FILE__

include Libv8::Arch
include Libv8::Make
include Libv8::Compiler

profile = enable_config('debug') ? 'debug' : 'release'

Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
  puts `env CXX=#{compiler} LINK=#{compiler} #{make} #{libv8_arch}.#{profile} GYPFLAGS="-Dhost_arch=#{libv8_arch}"`
end
exit $?.exitstatus
