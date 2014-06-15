require 'spec_helper'
require 'compiler'

module Libv8
  describe Compiler do
    describe '::type_of' do
      it 'recognises correctly GCC' do
        stub_as_available 'c++', :gcc, '4.9.0'
        Compiler.available_compilers('c++').first.should be_a Compiler::GCC

        stub_as_available 'g++', :gcc, '4.2.1-freebsd'
        Compiler.available_compilers('g++').first.should be_a Compiler::GCC
      end

      it 'recognises correctly Clang' do
        stub_as_available 'c++', :clang, '3.4.1'
        Compiler.available_compilers('c++').first.should be_a Compiler::Clang

        stub_as_available 'freebsd-clang++', :clang, '3.3-freebsd'
        Compiler.available_compilers('freebsd-clang++').first.should be_a Compiler::Clang
      end

      it 'recognises correctly Apple\'s LLVM' do
        stub_as_available 'c++', :apple_llvm, '5.1'
        Compiler.available_compilers('c++').first.should be_a Compiler::AppleLLVM
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
