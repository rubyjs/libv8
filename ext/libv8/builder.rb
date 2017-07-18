unless $:.include? File.expand_path("../../../lib", __FILE__)
  $:.unshift File.expand_path("../../../lib", __FILE__)
end
require 'mkmf'
require 'rbconfig'
require 'shellwords'
require 'libv8/version'
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

    def gyp_defines(*defines)
      # Do not use an external snapshot as we don't really care for binary size
      defines << 'v8_use_external_startup_data=0'

      # Do not use the embedded toolchain
      defines << 'use_sysroot=0'
      defines << 'linux_use_bundled_binutils=0'
      defines << 'linux_use_bundled_gold=0'
      defines << 'make_clang_dir=""'
      defines << 'clang_dir=""'

      # Pass clang flag to GYP in order to work around GCC compilation failures
      defines << "clang=#{@compiler.is_a?(Compiler::Clang) ? '1' : '0'}"

      # Add contents of the GYP_DEFINES environment variable if present
      defines << ENV['GYP_DEFINES'] unless ENV['GYP_DEFINES'].nil?

      "GYP_DEFINES=\"#{defines.join ' '}\""
    end

    def make_flags(*flags)
      # Disable i18n
      flags << 'i18nsupport=off'

      # Solaris / Smart OS requires additional -G flag to use with -fPIC
      flags << "CFLAGS=-G" if @compiler.target =~ /solaris/

      # Disable werror as this version of v8 is getting difficult to maintain
      # with it on
      flags << 'werror=no'

      # Append GYP variable definitions
      flags << gyp_defines

      # Append manually specified MAKEFLAGS
      flags << ENV['MAKEFLAGS'] if ENV['MAKEFLAGS']
      ENV['MAKEFLAGS'] = nil

      "#{make_target} #{flags.join ' '}"
    end

    def build_libv8!
      setup_python!
      setup_build_deps!
      Dir.chdir(File.expand_path('../../../vendor/v8', __FILE__)) do
        fail 'No compilers available' if @compiler.nil?
        patch!
        print_build_info
        puts 'Beginning compilation. This will take some time.'

        command = "env CXX=#{Shellwords.escape @compiler.to_s} #{make} #{make_flags}"
        puts "Building v8 with #{command}"
        system command
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

    ##
    # The release tag to checkout. If this is version 4.5.95.0 of the libv8 gem,
    # then this will be 4.5.95
    #
    def source_version
      Libv8::VERSION.gsub(/\.[^.]+$/, '')
    end

    ##
    # Checkout all of the V8 source and its dependencies using the
    # chromium depot tools.
    #
    # https://chromium.googlesource.com/v8/v8.git#Getting-the-Code
    #
    def setup_build_deps!
      ENV['PATH'] = "#{File.expand_path('../../../vendor/depot_tools', __FILE__)}:#{ENV['PATH']}"
      Dir.chdir(File.expand_path('../../../vendor', __FILE__)) do
        unless Dir.exists? 'v8'
          system "env #{gyp_defines} fetch v8" or fail "unable to fetch v8 source"
        else
          system "env #{gyp_defines} gclient fetch" or fail "could not fetch v8 build dependencies commits"
        end
        Dir.chdir('v8') do
          unless system "git checkout #{source_version}"
            fail "unable to checkout source for v8 #{source_version}"
          end
          system "env #{gyp_defines} gclient sync" or fail "could not sync v8 build dependencies"
          system "git checkout Makefile" # Work around a weird bug on FreeBSD
        end
      end
    end

    private

    def choose_compiler
      compiler = if with_config('cxx') || ENV['CXX']
                   with_config('cxx') || ENV['CXX']
                 else
                   begin
                     MakeMakefile::CONFIG['CXX'] # stdlib > 2.0.0
                   rescue NameError
                     RbConfig::CONFIG['CXX'] # stdlib < 2.0.0
                   end
                 end

      Libv8::Compiler.type_of(compiler).new compiler
    end

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

      puts "Using compiler: #{@compiler} (#{@compiler.name} version #{@compiler.version})"
      unless @compiler.compatible?
        warn "Unable to find a compiler officially supported by v8."
        warn "It is recommended to use clang v3.5 or GCC v4.8 or higher"
      end
    end
  end
end
