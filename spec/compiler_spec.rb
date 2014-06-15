require 'spec_helper'
require 'compiler'

module Libv8
  describe Compiler do
    describe '::type_of' do
      it 'returns a GCC class for GCC 4.9.0' do
        stub_as_available 'c++', :gcc, '4.9.0'
        Compiler.available_compilers('c++').first.should be_a Compiler::GCC
      end

      it 'returns a Clang class for Clang 3.4.1' do
        stub_as_available 'c++', :clang, '3.4.1'
        Compiler.available_compilers('c++').first.should be_a Compiler::Clang
      end
    end

    describe '::available_compilers' do
      it 'returns instances of the available compilers' do
        stub_as_available 'c++', :clang, '3.4.1'
        stub_as_unavailable 'g++'
        stub_as_available 'clang++', :clang, '3.4.1'

        available_compilers = Compiler.available_compilers 'c++', 'g++', 'clang++'
        available_compilers.map(&:class).should have(2).items
        available_compilers.all? { |compiler| compiler.should be_a Compiler::Clang }
      end
    end

    describe '::version_string_of' do
      context 'when calling the compiler command succedes' do
        it 'returns the version string of the compiler' do
          stub_as_available 'c++', :clang, '3.4.1'
          Compiler.version_string_of('c++').should eq version_output_of(:clang, '3.4.1')
        end
      end

      context 'when calling the compiler command fails' do
        it 'raises an exception' do
          stub_as_unavailable 'c++'
          expect { Compiler.version_string_of('c++') }.to raise_exception
        end
      end
    end

    describe '::available?' do
      it 'returns true when the command is available' do
        stub_as_available 'c++', :clang, '3.4.1'
        Compiler::available?('c++').should be_true
      end

      it 'returns false when the command cannot be found ' do
        stub_as_unavailable 'c++'
        Compiler::available?('c++').should be_false
      end
    end
  end
end
