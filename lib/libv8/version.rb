module Libv8
  V8_VERSION = Dir.chdir(File.join(File.dirname(__FILE__), 'v8')) { `git tag`.split.sort.last }
  REVISION = ""
  VERSION = V8_VERSION + REVISION
end
