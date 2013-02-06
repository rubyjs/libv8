module Libv8
  module Compiler
    module_function

    def compiler
      unless defined?(@compiler)
        compilers = ['g++', 'g++44', 'g++46', 'g++48']
        compilers << ENV['CXX'] if ENV['CXX']

        cxx = elect_compiler compilers

        if cxx.nil?
          warn "Unable to find a compiler officially supported by v8."
          warn "It is recommended to use GCC v4.4 or higher"
          @compiler = cxx = ENV['CXX'] ? ENV['CXX'] : 'g++'
        end

        puts "Using compiler: #{cxx}"
        @compiler = cxx
      end

      @compiler
    end

    def elect_compiler(compilers)
      compilers.delete_if { |name| !check_gcc_compiler(name) }.last
    end

    def target
      `#{compiler} -v 2>&1 | grep Target`.chomp.split.last
    end

    def config_flags
      `#{compiler} -v 2>&1 | grep 'Configured with'`.chomp.split(': ', 2).last
    end

    def check_gcc_compiler(name)
      compiler = `which #{name} 2> /dev/null`
      return nil unless $?.success?

      compiler.chomp!
      return nil unless `#{compiler} --version` =~ /([0-9]\.[0-9]\.[0-9])/

      return nil if $1 < "4.4"
      compiler
    end

    def check_clang_compiler(name)
      compiler = `which #{name} 2> /dev/null`
      return nil unless $?.success?
      compiler.chomp
    end
  end
end
