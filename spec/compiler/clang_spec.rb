require 'spec_helper'
require 'compiler'

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
        end
      end
    end
  end
end
