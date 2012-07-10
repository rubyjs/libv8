require 'mkmf'
require 'libv8/arch'
module Libv8

  module_function

  def mingw?
    RUBY_PLATFORM =~ /mingw/
  end

  def libv8_object(name)
    filename = "#{libv8_source_path}/out/#{Libv8::Arch.libv8_arch}.release/libv8_#{name}.#{$LIBEXT}"
    unless File.exists? filename
      filename = "#{libv8_source_path}/out/#{Libv8::Arch.libv8_arch}.release/obj.target/tools/gyp/libv8_#{name}.#{$LIBEXT}"
    end
    unless File.exists? filename
      # SCons build
      filename = "#{libv8_source_path}/#{name}.#{$LIBEXT}"
    end
    filename
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
    if names.empty?
      names = if mingw?
        # SCons build
        [:libv8]
      else
        [:base, :snapshot]
      end
    end
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
