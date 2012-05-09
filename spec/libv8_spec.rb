require 'spec_helper'
require 'pathname'

describe Libv8 do
  include Libv8

  it "can find the static library components" do
    Pathname(libv8_base).should exist
    Pathname(libv8_snapshot).should exist
  end

  it "has a valid include path" do
    Pathname(libv8_include_path).should be_exist
  end

  it "can retrieve objects by name" do
    libv8_objects(:base, :snapshot).each do |obj|
      Pathname(obj).should exist
    end
  end

end
