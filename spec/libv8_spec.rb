require 'spec_helper'
require 'pathname'

describe Libv8 do
  include Libv8

  it "can find the static library components" do
    Pathname(libv8_base).should be_exist
    Pathname(libv8_snapshot).should be_exist
    Pathname(libv8_nosnapshot).should be_exist
  end
end
