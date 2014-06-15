module Libv8
  module Compiler
    class GenericCompiler
      VERSION_REGEXP = /(\d+\.\d+(\.\d+)*)/
      TARGET_REGEXP = /Target: ([a-z0-9\-_.]*)/

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
        call('-v').output =~ VERSION_REGEXP
        $1
      end

      def target
        call('-v').output =~ TARGET_REGEXP
        $1
      end

      def compatible?
        false
      end

      def call(*arguments)
        Compiler::execute_command arguments.unshift(@command).push('2>&1').join(' ')
      end
    end
  end
end
