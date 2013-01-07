require 'mkmf'
require File.expand_path '../compiler', __FILE__
require File.expand_path '../arch', __FILE__
require File.expand_path '../make', __FILE__

module Libv8
  class Builder
    include Libv8::Arch
    include Libv8::Compiler
    include Libv8::Make

    def gyp_flags(*flags)
      # Fix a compilation failure under MacOS.
      # See https://groups.google.com/d/topic/v8-users/Oj-efHLjygc/discussion
      flags << "-Dhost_arch=#{libv8_arch}" if RUBY_PLATFORM.include?("darwin")

      # FreeBSD uses gcc 4.2 by default which leads to
      # compilation failures due to warnings about aliasing.
      flags << "-Dv8_no_strict_aliasing=1" if RUBY_PLATFORM.include?("freebsd") and !check_gcc_compiler(compiler)

      %Q(GYPFLAGS+="#{flags.join(' ')}") unless flags.empty?
    end

    def make_flags(*flags)
      profile = enable_config('debug') ? 'debug' : 'release'
      flags << gyp_flags

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
