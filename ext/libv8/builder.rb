require 'mkmf'
require File.expand_path '../compiler', __FILE__
require File.expand_path '../arch', __FILE__
require File.expand_path '../make', __FILE__

module Libv8
  class Builder
    include Libv8::Arch
    include Libv8::Compiler
    include Libv8::Make

    def make_flags(*flags)
      profile = enable_config('debug') ? 'debug' : 'release'

      # FreeBSD uses gcc 4.2 by default which leads to
      # compilation failures due to warnings about aliasing.
      # http://svnweb.freebsd.org/ports/head/lang/v8/Makefile?view=markup
      flags << "strictaliasing=off" if RUBY_PLATFORM.include?("freebsd") and !check_gcc_compiler(compiler)

      # Fix Malformed archive issue caused by GYP creating thin archives by
      # default.
      flags << "ARFLAGS.target=crs"

      "#{libv8_arch}.#{profile} #{flags.join ' '}"
    end

    def build_libv8!
      Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
        puts `env CXX=#{compiler} LINK=#{compiler} #{make} #{make_flags}`
      end
      return $?.exitstatus
    end
  end
end
