require 'mkmf'
require 'pathname'

begin
  def crash(str)
    printf("Unable to build libv8: %s\n", str)
    exit 1
  end

  print "Checking for Python..."
  version = `python --version 2>&1`
  crash "Python not found!" if version.split.first != "Python"
  require 'rubygems'
  crash "Python 3.x is unsupported by V8!" if Gem::Version.new(version.split.last) >= Gem::Version.new(3)
  crash "Python 2.4+ is required by V8!" if Gem::Version.new(version.split.last) < Gem::Version.new("2.4")
  puts version.split.last
rescue StandardError => e
  warn e
end


Dir.chdir(Pathname(__FILE__).dirname.join('..', '..', 'lib', 'libv8')) do
  puts "Compiling V8..."
  /GNU/ =~ `make --version 2>/dev/null` ? `make` : `gmake`
end

create_makefile('libv8')