module Libv8
  module Compiler
    class GCC < GenericCompiler
      VERSION_REGEXP = /gcc version (\d+\.\d+(\.\d+)*)/i

      def name
        'GCC'
      end

      def compatible?
        version > '4.3' unless version.nil?
      end
    end
  end
end
