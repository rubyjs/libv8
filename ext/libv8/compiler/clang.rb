module Libv8
  module Compiler
    class Clang < GenericCompiler
      CLANG_VERSION_REGEXP = /clang version (\d+\.\d+(\.\d+)*) \(/i

      def name
        'clang'
      end

      def compatible?
        version >= '3.1' unless version.nil?
      end

      private

      def version_regexp
        CLANG_VERSION_REGEXP
      end
    end
  end
end
