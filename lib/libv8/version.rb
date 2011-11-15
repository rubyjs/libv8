module Libv8
  version_file = File.join(File.dirname(__FILE__), 'VERSION')
  V8_VERSION = File.exist?(version_file) ? File.read(version_file).chomp : "0.0"
  REVISION = ".4"
  VERSION = V8_VERSION + REVISION
end
