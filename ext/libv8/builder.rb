unless $:.include? File.expand_path("../../../lib", __FILE__)
  $:.unshift File.expand_path("../../../lib", __FILE__)
end
require 'mkmf'
require 'rbconfig'
require 'shellwords'
require 'libv8/version'
require File.expand_path '../arch', __FILE__

module Libv8
  class Builder
    include Libv8::Arch

    def gn_args
      %W(is_debug=#{debug_build? ? 'true' : 'false'}
         symbol_level=#{debug_build? ? '-1' : '0'}
         is_component_build=false
         v8_monolithic=true
         v8_use_external_startup_data=false
         target_cpu="#{libv8_arch}"
         v8_target_cpu="#{libv8_arch}"
         treat_warnings_as_errors=false
         v8_enable_i18n_support=false).join(' ')
    end

    def generate_gn_args
      system "gn gen out.gn/libv8 --args='#{gn_args}'"
    end

    def debug_build?
      enable_config('debug')
    end

    def build_libv8!
      setup_python!
      setup_build_deps!
      Dir.chdir(File.expand_path('../../../vendor/v8', __FILE__)) do
        puts 'Beginning compilation. This will take some time.'
        generate_gn_args

        system 'ninja -v -C out.gn/libv8 v8_monolith'
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
        unless Dir.exists?('v8') || File.exists?('.gclient')
          system "fetch v8" or fail "unable to fetch v8 source"
        end

        Dir.chdir('v8') do
          system 'git fetch origin'
          unless system "git checkout #{source_version}"
            fail "unable to checkout source for v8 #{source_version}"
          end
          system "gclient sync" or fail "could not sync v8 build dependencies"
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
  end
end
