module Libv8
  module Compiler
    class AppleLLVM < Clang
      LLVM_VERSION_REGEXP = /Apple LLVM version (\d+\.\d+(\.\d+)*) \(/i
      REQUIRED_VERSION = '4.3'

      def name
        'Apple LLVM'
      end

      private

      def required_version
        REQUIRED_VERSION
      end

      def version_regexp
        LLVM_VERSION_REGEXP
      end
    end
  end
end
