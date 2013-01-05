require File.expand_path '../compiler', __FILE__
require File.expand_path '../arch', __FILE__
require File.expand_path '../make', __FILE__

module Libv8
  class Builder
    include Libv8::Arch
    include Libv8::Compiler
    include Libv8::Make

    def build_libv8!
      profile = enable_config('debug') ? 'debug' : 'release'

      Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
        puts `env CXX=#{compiler} LINK=#{compiler} #{make} #{libv8_arch}.#{profile} GYPFLAGS="-Dhost_arch=#{libv8_arch}"`
      end
      return $?.exitstatus
    end
  end
end
