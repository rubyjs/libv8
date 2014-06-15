require 'spec_helper'
require 'compiler'

module Libv8::Compiler
  describe GenericCompiler do
    subject { GenericCompiler.new 'c++' }

    describe '#name' do
      it 'returns just the base name of the command' do
        GenericCompiler.new('/usr/sbin/c++').name.should eq 'c++'
      end
    end

    describe '#to_s' do
      it 'should be the command used to call the compiler' do
        subject.to_s.should eq 'c++'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :clang, '3.4.1'
        subject.version.should eq '3.4.1'
      end

      it 'returns nil when determining the version fails' do
        stub_as_unavailable 'c++'
        subject.version.should be_nil
      end
    end

    describe '#target' do
      it 'returns the target of the compiler' do
        stub_as_available 'c++', :clang, '3.4.1'
        subject.target.should eq 'x86_64-unknown-linux-gnu'
      end

      it 'returns nil when determining the target fails' do
        stub_as_unavailable 'c++'
        subject.target.should be_nil
      end
    end

    describe '#compatible?' do
      it 'returns false' do
        GenericCompiler.new('c++').compatible?.should be_false
      end
    end
  end
end
