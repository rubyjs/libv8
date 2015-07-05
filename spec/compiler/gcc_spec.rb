require 'spec_helper'
require 'compiler'

module Libv8::Compiler
  describe GCC do
    subject { GCC.new 'c++' }

    describe '#name' do
      it 'returns GCC' do
        expect(subject.name).to eq 'GCC'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :gcc, '4.9.0'
        expect(subject.version).to eq '4.9.0'
      end
    end

    describe '#compatible?' do
      context 'when GCC\'s version is >= 4.8' do
        it 'returns true' do
          stub_as_available 'c++', :gcc, '4.9.0'
          expect(subject).to be_compatible
        end
      end

      context 'when GCC\'s version is < 4.3' do
        it 'returns false' do
          stub_as_available 'c++', :gcc, '4.2.1-freebsd'
          expect(subject).to_not be_compatible
        end
      end
    end
  end
end
