require 'pathname'

require 'libv8/version'

module Libv8
  LIBRARY_PATH = Pathname(__FILE__).dirname.join('libv8', 'build', 'v8').to_s
  def self.library_path
    LIBRARY_PATH
  end
  
  INCLUDE_PATH = Pathname(__FILE__).dirname.join('libv8', 'v8', 'include').to_s
  def self.include_path
    INCLUDE_PATH
  end
end
