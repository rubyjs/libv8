require 'rubygems'

module Libv8
  module Arch
    module_function

    def libv8_arch
      case Gem::Platform.local.cpu
      when /^arm(v6.*|v7.*)*$/ then 'arm'
      when /^a(rm|arch)64$/    then 'arm64'
      when /^x86$/             then 'ia32'
      when /^(x86_64|amd64)$/  then 'x64'
      when /^universal$/       then 'x64' # OS X
      else
        warn "Unsupported target: #{Gem::Platform.local.cpu}"
        Gem::Platform.local.cpu
      end
    end
  end
end
