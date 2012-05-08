require 'mkmf'
create_makefile('libv8')
require File.expand_path '../arch.rb', __FILE__

include Libv8::Arch

Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
  puts `make #{libv8_arch}.release`
end
