require 'pathname'

require 'libv8/version'

module Libv8
  def self.LIB_PATH
    Pathname(__FILE__).dirname.join('libv8', 'build', 'v8', 'libv8.a')
  end
end
