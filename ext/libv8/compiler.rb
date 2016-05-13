require 'rbconfig'
require File.expand_path '../compiler/generic_compiler', __FILE__
require File.expand_path '../compiler/gcc', __FILE__
require File.expand_path '../compiler/clang', __FILE__
require File.expand_path '../compiler/apple_llvm', __FILE__

module Libv8
  module Compiler
    module_function

    def type_of(compiler)
      case version_string_of(compiler)
      when /^Apple LLVM\b/ then AppleLLVM
      when /\bclang\b/i then Clang
      when /^gcc/i then GCC
      else GenericCompiler
      end
    end

    def version_string_of(compiler)
      command_result = execute_command "env LC_ALL=C LANG=C #{compiler} -v 2>&1"

      unless command_result.status.success?
        raise "Could not get version string of compiler #{compiler}"
      end

      command_result.output
    end

    def execute_command(command)
      output = `#{command}`
      status = $?
      ExecutionResult.new output, status
    end

    class ExecutionResult < Struct.new(:output, :status)
    end
  end
end
