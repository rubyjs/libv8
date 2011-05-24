require 'mkmf'
require 'pathname'

puts "Compiling V8..."

Dir.chdir(Pathname(__FILE__).dirname.join('..', '..', 'lib', 'libv8')) do
  `make`
end

create_makefile('libv8')