require 'mkmf'
require 'pathname'

Dir.chdir(Pathname(__FILE__).dirname.join('..', '..', 'lib', 'libv8')) do
  puts "Compiling V8..."
  `make`
end

create_makefile('libv8')