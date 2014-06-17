require 'rbconfig'
require 'rubygems'

module Libv8
  module Arch
    module_function
    def libv8_arch
      case Gem::Platform.local.cpu
      when /^armv8|^aarch64/ then 'arm64'
      when /^arm/            then 'arm'
      when /^mips/           then 'mips'
      when /^amd64|^x86_64/  then 'x64'
      when /^i[3456]86/      then 'ia32'
      else raise "Unsupported target: #{Gem::Platform.local.cpu}"
      end
    end
  end
end
