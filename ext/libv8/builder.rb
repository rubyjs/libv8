require 'mkmf'
require File.expand_path '../compiler', __FILE__
require File.expand_path '../make', __FILE__

module Libv8
  class Builder
    include Libv8::Compiler
    include Libv8::Make

    def initialize(target = :native)
      @target = target
    end

    def libv8_arch
      case target
      when /^amd64|^x86_64/ then 'x64'
      when /^arm/           then 'arm'
      when /^mips/          then 'mips'
      when /mingw32$/       then 'mingw32'
      when /^i[3456]86/     then 'ia32'
      else raise "Unsupported target #{target}"
      end
    end

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
        setup_python!
        puts `env CXX=#{compiler} LINK=#{compiler} #{make} #{make_flags} -j8`
      end
      return $?.exitstatus
    end

    def setup_python!
      # If python v2 cannot be found in PATH,
      # create a symbolic link to python2 the current directory and put it
      # at the head of PATH. That way all commands that inherit this environment
      # will use ./python -> python2
      if python_version !~ /^2/
        unless system 'which python2 2>&1 > /dev/null'
          fail "libv8 requires python 2 to be installed in order to build, but it is currently #{python_version}"
        end
        `ln -fs #{`which python2`.chomp} python`
        ENV['PATH'] = "#{File.expand_path '.'}:#{ENV['PATH']}"
      end
      puts "using python #{python_version}"
    end

    private

    def python_version
      if system 'which python 2>&1 > /dev/null'
        `python -c 'import platform; print platform.python_version()'`.chomp
      else
        "not available"
      end
    end
  end
end
