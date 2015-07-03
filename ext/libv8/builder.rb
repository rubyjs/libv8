require 'mkmf'
require File.expand_path '../compiler', __FILE__
require File.expand_path '../arch', __FILE__
require File.expand_path '../make', __FILE__
require File.expand_path '../patcher', __FILE__

module Libv8
  class Builder
    include Libv8::Arch
    include Libv8::Make
    include Libv8::Patcher

    def initialize
      @compiler = choose_compiler
    end

    def make_target
      profile = enable_config('debug') ? 'debug' : 'release'
      "#{libv8_arch}.#{profile}"
    end

    def make_flags(*flags)
      # FreeBSD uses gcc 4.2 by default which leads to
      # compilation failures due to warnings about aliasing.
      # http://svnweb.freebsd.org/ports/head/lang/v8/Makefile?view=markup
      flags << "strictaliasing=off" if @compiler.is_a?(Compiler::GCC) and @compiler.version < '4.4'

      # Check which ARM features are available according to the compiler
      # XXX: Needs testing
      flags << "armtest=on" if @compiler.target.include? "arm"

      # Fix Malformed archive issue caused by GYP creating thin archives by
      # default.
      flags << "ARFLAGS.target=crs"

      # Pass clang=1 to GYP as noted in wiki
      # https://code.google.com/p/v8/wiki/BuildingWithGYP#Clang_+_make
      flags << 'GYP_DEFINES="clang=1"' if @compiler.is_a? Compiler::Clang

      # Disable i18n
      flags << 'i18nsupport=off'

      # Solaris / Smart OS requires additional -G flag to use with -fPIC
      flags << "CFLAGS=-G" if @compiler.target =~ /solaris/

      # Disable werror as this version of v8 is getting difficult to maintain
      # with it on
      flags << 'werror=no'

      "#{make_target} #{flags.join ' '}"
    end

    def build_libv8!
      Dir.chdir(File.expand_path('../../../vendor/v8', __FILE__)) do
        fail 'No compilers available' if @compiler.nil?
        setup_python!
        setup_build_deps!
        patch!
        print_build_info
        puts 'Beginning compilation. This will take some time.'
        system "env CXX=#{@compiler} LINK=#{@compiler} #{make} #{make_flags}"
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
      gclient = File.expand_path('../../../vendor/depot_tools/gclient', __FILE__)
      `#{gclient} sync`
    end

    private

    def choose_compiler
      compiler_names = if with_config('cxx') then [with_config('cxx')]
                       elsif ENV['CXX']      then [ENV['CXX']]
                       else                       Compiler::well_known_compilers
                       end

      available_compilers = Compiler.available_compilers(*compiler_names)
      compatible_compilers = available_compilers.select(&:compatible?)

      unless compatible_compilers.empty? then compatible_compilers
      else available_compilers
      end.first
    end

    def python_version
      if `which python` =~ /python/
        `python -c "import platform; print(platform.python_version())"`.chomp
      else
        "not available"
      end
    end

    def print_build_info
      puts "Compiling v8 for #{libv8_arch}"

      puts "Using python #{python_version}"

      puts "Using compiler: #{@compiler} (#{@compiler.name} version #{@compiler.version})"
      unless @compiler.compatible?
        warn "Unable to find a compiler officially supported by v8."
        warn "It is recommended to use GCC v4.4 or higher"
      end
    end
  end
end
