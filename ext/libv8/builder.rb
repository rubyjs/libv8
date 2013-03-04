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

      # Avoid compilation failures on the Raspberry Pi.
      flags << "vfp2=off vfp3=off" if RUBY_PLATFORM.include? "arm"

      # Enable hardfloat support if available.
      flags << "hardfp=on" if RUBY_PLATFORM.include? "eabihf"

      # Fix Malformed archive issue caused by GYP creating thin archives by
      # default.
      flags << "ARFLAGS.target=crs"

      "#{libv8_arch}.#{profile} #{flags.join ' '}"
    end

    def build_libv8!
      Dir.chdir(File.expand_path '../../../vendor/v8', __FILE__) do
        setup_python!
        print_build_info
        puts `env CXX=#{compiler} LINK=#{compiler} #{make} #{make_flags}`
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
    end

    private

    def python_version
      if system 'which python 2>&1 > /dev/null'
        `python -c 'import platform; print(platform.python_version())'`.chomp
      else
        "not available"
      end
    end

    def print_build_info
      puts "Compiling v8 for #{libv8_arch}"

      puts "Using python #{python_version}"

      puts "Using compiler: #{compiler}"
      unless check_gcc_compiler compiler
        warn "Unable to find a compiler officially supported by v8."
        warn "It is recommended to use GCC v4.4 or higher"
      end
    end
  end
end
