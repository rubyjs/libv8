module Libv8
  module Compiler
    class GenericCompiler
      GENERIC_VERSION_REGEXP = /(\d+\.\d+(\.\d+)*)/
      GENERIC_TARGET_REGEXP = /Target: ([a-z0-9\-_.]*)/

      def initialize(command)
        @command = command
      end

      def name
        File.basename @command
      end

      def to_s
        @command
      end

      def version
        version_string =~ version_regexp
        $1
      end

      def target
        version_string =~ target_regexp
        $1
      end

      def compatible?
        false
      end

      def call(*arguments)
        Compiler::execute_command arguments.unshift(@command).join(' ')
      end

      private

      def version_string
        begin
          Compiler::version_string_of @command
        rescue StandardError
          nil
        end
      end

      def version_regexp
        GENERIC_VERSION_REGEXP
      end

      def target_regexp
        GENERIC_TARGET_REGEXP
      end
    end
  end
end
