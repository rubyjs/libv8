module Libv8
  module Compiler
    module_function

    def compiler
      unless defined?(@compiler)
        cc   = check_gcc_compiler "g++"

        # Check alternative GCC names
        # These are common on BSD's after
        # GCC has been installed by a port
        cc ||= check_gcc_compiler "g++44"
        cc ||= check_gcc_compiler "g++46"
        cc ||= check_gcc_compiler "g++48"

        if cc.nil?
          puts "Unable to find a suitable compiler."
          puts "Install GCC v4.4 or higher"
          exit 1
        end

        puts "Using compiler: #{cc}"
        @compiler = cc
      end

      @compiler
    end

    def check_gcc_compiler(name)
      compiler = `which #{name}`
      return nil unless $?.success?

      compiler.chomp!
      return nil unless `#{compiler} --version` =~ /([0-9]\.[0-9]\.[0-9])/

      return nil if $1 < "4.4"
      compiler
    end

    def check_clang_compiler(name)
      compiler = `which #{name}`
      return nil unless $?.success?
      compiler.chomp
    end
  end
end
