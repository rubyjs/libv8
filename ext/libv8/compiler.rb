require 'rbconfig'
require File.expand_path '../compiler/generic_compiler', __FILE__
require File.expand_path '../compiler/gcc', __FILE__
require File.expand_path '../compiler/clang', __FILE__
require File.expand_path '../compiler/apple_llvm', __FILE__

module Libv8
  module Compiler
    module_function

    def well_known_compilers
      compilers = []

      # The default system compiler
      compilers << 'c++'

      # FreeBSD GCC command names
      compilers += ['g++48', 'g++49', 'g++5', 'g++6', 'g++7']

      # Default compiler names
      compilers += ['clang++', 'g++']

      compilers.uniq
    end

    def available_compilers(*compiler_names)
      available = compiler_names.select { |compiler_name| available? compiler_name }
      available.map { |compiler_name| type_of(compiler_name).new compiler_name }
    end

    def type_of(compiler_name)
      case version_string_of(compiler_name)
      when /^Apple LLVM\b/ then AppleLLVM
      when /\bclang\b/i then Clang
      when /^gcc/i then GCC
      else GenericCompiler
      end
    end

    def version_string_of(compiler_name)
      command_result = execute_command "#{compiler_name} -v 2>&1"

      unless command_result.status.success?
        raise "Could not get version string of compiler #{compiler_name}"
      end

      command_result.output
    end

    def available?(command)
      execute_command("which #{command} 2>&1").status.success?
    end

    def execute_command(command)
      output = `env LC_ALL=C LANG=C #{command}`
      status = $?
      ExecutionResult.new output, status
    end

    class ExecutionResult < Struct.new(:output, :status)
    end
  end
end
