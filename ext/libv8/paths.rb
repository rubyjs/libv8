require 'rbconfig'
require 'shellwords'

module Libv8
  module Paths
    module_function

    def include_paths
      [Shellwords.escape(File.join(vendored_source_path, 'include'))]
    end

    def object_paths
      [Shellwords.escape(File.join(vendored_source_path,
                                   'out.gn',
                                   'libv8',
                                   'obj',
                                   "libv8_monolith.#{config['LIBEXT']}"))]
    end

    def config
      RbConfig::MAKEFILE_CONFIG
    end

    def vendored_source_path
      File.expand_path "../../../vendor/v8", __FILE__
    end
  end
end
