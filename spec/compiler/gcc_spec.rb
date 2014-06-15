$:.unshift File.expand_path '../../../ext/libv8', __FILE__

require 'spec_helper'
require 'compiler'

RSpec.configure do |c|
  c.include CompilerHelpers
end

module Libv8::Compiler
  describe GCC do
    subject { GCC.new 'c++' }

    describe '#name' do
      it 'returns GCC' do
        subject.name.should eq 'GCC'
      end
    end

    describe '#version' do
      it 'returns the version of the compiler' do
        stub_as_available 'c++', :gcc, '4.9.0'
        subject.version.should eq '4.9.0'
      end
    end

    describe '#compatible?' do
      context 'when GCC\'s version is >= 4.3' do
        it 'returns true' do
          stub_as_available 'c++', :gcc, '4.9.0'
          subject.compatible?.should be_true
        end
      end

      context 'when GCC\'s version is < 4.3' do
        it 'returns false' do
          stub_as_available 'c++', :gcc, '4.2.1-freebsd'
          subject.compatible?.should be_false
        end
      end
    end
  end
end
