require 'mkmf'
require File.expand_path '../compiler', __FILE__
require File.expand_path '../arch', __FILE__
require File.expand_path '../make', __FILE__
require File.expand_path '../checkout', __FILE__

module Libv8
  class Builder
    include Libv8::Arch
    include Libv8::Compiler
    include Libv8::Make
    include Libv8::Checkout

    def make_flags(*flags)
      profile = enable_config('debug') ? 'debug' : 'release'

      # FreeBSD uses gcc 4.2 by default which leads to
      # compilation failures due to warnings about aliasing.
      # http://svnweb.freebsd.org/ports/head/lang/v8/Makefile?view=markup
      flags << "strictaliasing=off" if RUBY_PLATFORM.include?("freebsd") and !check_gcc_compiler(compiler)

      # Avoid compilation failures on the Raspberry Pi.
      flags << "vfp2=off vfp3=off" if RUBY_PLATFORM.include? "arm"

      # FIXME: Determine when to activate this instead of leaving it on by
      # default.
      flags << "hardfp=on" if RUBY_PLATFORM.include? "arm"

      # Fix Malformed archive issue caused by GYP creating thin archives by
      # default.
      flags << "ARFLAGS.target=crs"

      # Solaris / Smart OS requires additional -G flag to use with -fPIC
      flags << "CFLAGS=-G" if RUBY_PLATFORM =~ /solaris/

      "#{libv8_arch}.#{profile} #{flags.join ' '}"
    end

    def build_libv8!
      Dir.chdir(V8_Source) do
        checkout!
        setup_python!
        setup_build_deps!
        apply_patches!
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

    def setup_build_deps!
      # This uses the Git mirror of the svn repository used by
      # "make dependencies", instead of calling that make target
      `rm -rf build/gyp`
      `ln -fs #{GYP_Source} build/gyp`
    end

    def apply_patches!
      File.open(".applied_patches", File::RDWR|File::CREAT) do |f|
        available_patches = Dir.glob(File.expand_path '../../../patches/*.patch', __FILE__).sort
        applied_patches = f.readlines.map(&:chomp)

        (available_patches - applied_patches).each do |patch|
          `patch -p1 -N < #{patch}`
          f.puts patch
        end
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
