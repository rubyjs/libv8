module Libv8
  module Compiler
    class AppleLLVM < Clang
      LLVM_VERSION_REGEXP = /Apple LLVM version (\d+\.\d+(\.\d+)*) \(/i

      def name
        'Apple LLVM'
      end

      def compatible?
        version >= '4.3' unless version.nil?
      end

      private

      def version_regexp
        LLVM_VERSION_REGEXP
      end
    end
  end
end
