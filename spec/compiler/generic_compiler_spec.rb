require 'spec_helper'
require 'compiler'

module Libv8::Compiler
  describe GenericCompiler do
    subject { GenericCompiler.new 'c++' }

    describe '#name' do
      it 'returns just the base name of the command' do
        expect(GenericCompiler.new('/usr/sbin/c++').name).to eq 'c++'
      end
    end

    describe '#to_s' do
      it 'should be the command used to call the compiler' do
        expect(subject.to_s).to eq 'c++'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :clang, '3.4.1'
        expect(subject.version).to eq '3.4.1'
      end

      it 'returns nil when determining the version fails' do
        stub_as_unavailable 'c++'
        expect(subject.version).to be_nil
      end
    end

    describe '#target' do
      it 'returns the target of the compiler' do
        stub_as_available 'c++', :clang, '3.4.1'
        expect(subject.target).to eq 'x86_64-unknown-linux-gnu'
      end

      it 'returns nil when determining the target fails' do
        stub_as_unavailable 'c++'
        expect(subject.target).to be_nil
      end
    end

    describe '#compatible?' do
      it 'returns false' do
        expect(GenericCompiler.new('c++')).to_not be_compatible
      end
    end
  end
end
