require 'rbconfig'

require 'libv8/arch'
module Libv8

  module_function

  def config
    Config::MAKEFILE_CONFIG
  end

  def libv8_object(name)
    filename = "#{libv8_profile}/libv8_#{name}.#{config['LIBEXT']}"
    unless File.exists? filename
      filename = "#{libv8_profile}/obj.target/tools/gyp/libv8_#{name}.#{config['LIBEXT']}"
    end
    return filename
  end

  def libv8_profile
    base = "#{libv8_source_path}/out/#{Libv8::Arch.libv8_arch}"
    debug = "#{base}.debug"
    File.exists?(debug) ? debug : "#{base}.release"
  end

  def libv8_base
    libv8_object :base
  end

  def libv8_snapshot
    libv8_object :snapshot
  end

  def libv8_nosnapshot
    libv8_object :nosnapshot
  end

  def libv8_objects(*names)
    names = [:base, :snapshot] if names.empty?
    names.map do |name|
      fail "no libv8 object #{name}" unless File.exists?(object = libv8_object(name))
      object
    end
  end

  def libv8_ldflags
    "-L#{libv8_base} -L#{libv8_snapshot}"
  end

  def libv8_include_flags
    "-I#{libv8_include_path}"
  end

  def libv8_include_path
    "#{libv8_source_path}/include"
  end

  def libv8_source_path
    File.expand_path "../../vendor/v8", __FILE__
  end
end
