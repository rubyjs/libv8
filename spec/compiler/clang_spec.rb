require 'spec_helper'
require 'compiler'

module Libv8::Compiler
  describe Clang do
    subject { Clang.new 'c++' }

    describe '#name' do
      it 'returns clang' do
        expect(subject.name).to eq 'clang'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :clang, '3.4.1'
        expect(subject.version).to eq '3.4.1'
      end
    end

    describe '#compatible?' do
      context 'when clang\'s version is >= 3.1' do
        it 'returns true' do
          stub_as_available 'c++', :clang, '3.4.1'
          expect(subject).to be_compatible
        end
      end

      context 'when clang\'s version is < 3.1' do
        it 'returns false' do
          stub_as_available 'c++', :clang, '3.0.9'
          expect(subject).to_not be_compatible
        end
      end
    end
  end
end
