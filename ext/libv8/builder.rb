unless $:.include? File.expand_path("../../../lib", __FILE__)
  $:.unshift File.expand_path("../../../lib", __FILE__)
end
require 'fileutils'
require 'mkmf'
require 'rbconfig'
require 'shellwords'
require 'libv8/version'
require File.expand_path '../arch', __FILE__

module Libv8
  class Builder
    include Libv8::Arch

    def gn_args
      %W(clang_use_chrome_plugins=false
         linux_use_bundled_binutils=false
         use_custom_libcxx=false
         use_sysroot=false
         is_debug=#{debug_build? ? 'true' : 'false'}
         symbol_level=#{debug_build? ? '-1' : '0'}
         is_component_build=false
         v8_monolithic=true
         v8_use_external_startup_data=false
         target_cpu="#{libv8_arch}"
         v8_target_cpu="#{libv8_arch}"
         treat_warnings_as_errors=false
         icu_use_data_file=false).join(' ')
    end

    def generate_gn_args
      system "gn gen out.gn/libv8 --args='#{gn_args}'"
    end

    def debug_build?
      enable_config('debug') || Libv8::VERSION.include?('beta')
    end

    def build_libv8!
      setup_depot_tools!
      setup_python!
      setup_build_deps!
      setup_ninja!
      setup_gn!
      Dir.chdir(File.expand_path('../../../vendor/v8', __FILE__)) do
        puts 'Beginning compilation. This will take some time.'
        generate_gn_args

        system 'ninja -v -C out.gn/libv8 v8_monolith'
      end
      return $?.exitstatus
    end

    def setup_depot_tools!
      ENV['PATH'] = "#{File.expand_path('../../../vendor/depot_tools', __FILE__)}:#{ENV['PATH']}"
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

      if arch_ppc64?
        unless system 'which python3 2>&1 > /dev/null'
          fail "libv8 requires python 3 to be installed in order to build"
        end

        # Because infra/3pp/tools/cpython3/linux-ppc64le@version:3.8.0.chromium.8 CIPD is not yet available
        # fallback to host's python3
        ENV['VPYTHON_BYPASS'] = 'manually managed python not supported by chrome operations'

        # stub the CIPD cpython3 with host's python3
        FileUtils.symlink(`which python3`.chomp, File.expand_path("../../../vendor/depot_tools/python3", __FILE__), force: true)
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
    def setup_build_deps!
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

    ##
    # Build ninja for linux ppc64le
    #
    def setup_ninja!
      return unless arch_ppc64?

      ninja_filepath = File.expand_path("../../../vendor/depot_tools/ninja-linux-ppc64le", __FILE__)
      return if File.exists?(ninja_filepath)

      Dir.chdir("/tmp") do
        FileUtils.rm_rf("ninja")
        system "git clone https://github.com/ninja-build/ninja.git -b v1.8.2" or fail "unable to git clone ninja repository"
      end

      Dir.chdir("/tmp/ninja") do
        system "python2 ./configure.py --bootstrap" or fail "unable to build ninja"
        FileUtils.mv(File.expand_path("#{Dir.pwd}/ninja"), ninja_filepath)
      end

      patch_filepath = File.expand_path("../../../vendor/patches/0001-support-ninja-ppc64le.patch", __FILE__)
      Dir.chdir(File.expand_path('../../../vendor/depot_tools', __FILE__)) do
        system "patch -p1 < #{patch_filepath}" or fail "unable to patch depot_tools/ninja"
      end
    end

    ##
    # Build gn for linux ppc64le
    # Upstream issue: https://bugs.chromium.org/p/chromium/issues/detail?id=1076455
    # TODO: Remove once upstream has supported ppc64le
    #
    def setup_gn!
      return unless arch_ppc64?

      gn_filepath = File.expand_path("../../../vendor/depot_tools/gn-linux-ppc64le", __FILE__)
      return if File.exists?(gn_filepath)

      Dir.chdir("/tmp") do
        FileUtils.rm_rf("gn")
        system "git clone https://gn.googlesource.com/gn" or fail "unable to git clone gn repository"
      end

      Dir.chdir("/tmp/gn") do
        system "python2 build/gen.py"
        fail "unable to prepare gn for compilation" unless File.exists?(File.expand_path("#{Dir.pwd}/out/build.ninja"))
        system "ninja -C out" or fail "unable to build gn"
        FileUtils.mv(File.expand_path("#{Dir.pwd}/out/gn"), gn_filepath)
        FileUtils.rm_f(File.expand_path("../../../vendor/depot_tools/gn", __FILE__))
        FileUtils.symlink(gn_filepath, File.expand_path("../../../vendor/depot_tools/gn", __FILE__), force: true)
      end
    end

    private

    def arch_ppc64?
      libv8_arch == "ppc64"
    end

    def python_version
      if system 'which python 2>&1 > /dev/null'
        `python -c 'import platform; print(platform.python_version())'`.chomp
      else
        "not available"
      end
    end
  end
end
