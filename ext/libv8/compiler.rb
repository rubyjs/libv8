module Libv8
  module Compiler
    module_function

    def compiler
      unless defined?(@compiler)
        unless ENV['CXX']
          compilers = ['g++', 'g++48', 'g++46', 'g++44']
        else
          compilers = [ENV['CXX']]
        end

        @compiler = compilers.map { |compiler| check_gcc_compiler compiler }.compact.first
        @compiler ||= compilers.first
      end

      @compiler
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
