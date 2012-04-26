require 'mkmf'
require 'pathname'
create_makefile('libv8')

Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
  puts "compiling libv8"
  puts `make dependencies`
  puts `make native GYP_GENERATORS=make`
end
