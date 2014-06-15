$:.unshift File.expand_path '../../../ext/libv8', __FILE__

require 'spec_helper'
require 'compiler'

RSpec.configure do |c|
  c.include CompilerHelpers
end

module Libv8::Compiler
  describe Clang do
    subject { Clang.new 'c++' }

    describe '#name' do
      it 'returns clang' do
        subject.name.should eq 'clang'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :clang, '3.4.1'
        subject.version.should eq '3.4.1'
      end
    end

    describe '#compatible?' do
      context 'when clang\'s version is >= 3.1' do
        it 'returns true' do
          stub_as_available 'c++', :clang, '3.4.1'
          subject.compatible?.should be_true

          stub_as_available 'c++', :clang, '3.10.0'
          subject.compatible?.should be_true
        end
      end

      context 'when clang\'s version is < 3.1' do
        it 'returns false' do
          stub_as_available 'c++', :clang, '3.0.0'
          subject.compatible?.should be_false
        end
      end
    end
  end
end
