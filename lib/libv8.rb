require 'pathname'

require 'libv8/version'

module Libv8

  module_function

  def libv8(name)
    File.expand_path "../../vendor/v8/out/native/libv8_#{name}.a", __FILE__
  end

  def libv8_base
    libv8 :base
  end

  def libv8_snapshot
    libv8 :snapshot
  end

  def libv8_nosnapshot
    libv8 :nosnapshot
  end

  def libv8_ldflags
    "-l#{libv8_base} -l#{libv8_snapshot}"
  end
end
