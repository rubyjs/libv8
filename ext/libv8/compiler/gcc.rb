module Libv8
  module Compiler
    class GCC < GenericCompiler
      GCC_VERSION_REGEXP = /gcc version (\d+\.\d+(\.\d+)*)/i
      REQUIRED_VERSION = '4.7'

      def name
        'GCC'
      end

      private

      def required_version
        REQUIRED_VERSION
      end

      def version_regexp
        GCC_VERSION_REGEXP
      end
    end
  end
end
