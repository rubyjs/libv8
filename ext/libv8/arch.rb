require 'rbconfig'

module Libv8
  module Arch
    module_function

    def target
      ENV['TARGET'] or RbConfig::CONFIG['target']
    end

    def libv8_arch
      case target
      when /^arm/           then 'arm'
      when /^mips/          then 'mips'
      when /^amd64|^x86_64/ then 'x64'
      when /^i[3456]86/     then 'ia32'
      else raise "Unsupported target: #{target}"
      end
    end
  end
end
