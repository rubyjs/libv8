module Libv8
  module Compiler
    class Clang < GenericCompiler
      CLANG_VERSION_REGEXP = /clang version (\d+\.\d+(\.\d+)*) \(/i
      REQUIRED_VERSION = '3.1'

      def name
        'clang'
      end

      private

      def required_version
        REQUIRED_VERSION
      end

      def version_regexp
        CLANG_VERSION_REGEXP
      end
    end
  end
end
