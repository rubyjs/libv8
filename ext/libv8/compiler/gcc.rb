module Libv8
  module Compiler
    class GCC < GenericCompiler
      GCC_VERSION_REGEXP = /gcc version (\d+\.\d+(\.\d+)*)/i

      def name
        'GCC'
      end

      def compatible?
        version > '4.3' unless version.nil?
      end

      private

      def version_regexp
        GCC_VERSION_REGEXP
      end
    end
  end
end
