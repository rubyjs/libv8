require 'spec_helper'
require 'compiler'

module Libv8::Compiler
  describe AppleLLVM do
    subject { AppleLLVM.new 'c++' }

    describe '#name' do
      it 'returns Apple LLVM' do
        expect(subject.name).to eq 'Apple LLVM'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :apple_llvm, '4.20'
        expect(subject.version).to eq '4.20'
      end
    end

    describe '#compatible?' do
      context 'when Apple LLVM\'s version is >= 4.3' do
        it 'returns true' do
          stub_as_available 'c++', :apple_llvm, '4.20'
          expect(subject).to be_compatible
        end
      end

      context 'when Apple LLVM\'s version is < 4.3' do
        it 'returns false' do
          stub_as_available 'c++', :apple_llvm, '4.2'
          expect(subject).to_not be_compatible
        end
      end
    end
  end
end
