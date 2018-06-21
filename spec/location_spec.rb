require 'spec_helper'

describe "libv8 locations" do
  before do
    @context = double(:CompilationContext)
  end

  describe "the system location" do
    before do
      @location = Libv8::Location::System.new
      allow(@context).to receive :dir_config
    end

    describe "configuring a compliation context with it" do
      before do
        allow(@context).to receive(:find_header) {true}
        allow(@context).to receive(:have_library) {true}
        @location.configure @context
      end

      it "adds the include path to the front of the include flags" do
        expect(@context).to have_received(:dir_config).with('v8').at_least(:once)
        expect(@context).to have_received(:find_header).with('v8.h').at_least(:once)
        expect(@context).to have_received(:have_library).with('v8').at_least(:once)
      end
    end

    describe "when the v8 library cannot be found" do
      before do
        allow(@context).to receive(:find_header) {true}
        allow(@context).to receive(:have_library) {false}
      end

      it "raises a NotFoundError" do
        expect {@location.configure @context}.to raise_error Libv8::Location::System::NotFoundError
      end
    end

    describe "when the v8.h header cannot be found" do
      before do
        allow(@context).to receive(:find_header) {false}
        allow(@context).to receive(:have_library) {true}
      end

      it "raises a NotFoundError" do
        expect {@location.configure @context}.to raise_error Libv8::Location::System::NotFoundError
      end
    end
  end

  describe "the vendor location" do
    before do
      @location = Libv8::Location::Vendor.new
      allow(@context).to receive(:incflags) {@incflags ||= "-I/usr/include -I/usr/local/include"}
      allow(@context).to receive(:ldflags) {@ldflags ||= "-lobjc -lpthread"}

      allow(Libv8::Paths).to receive(:vendored_source_path) {"/foo bar/v8"}
      @location.configure @context
    end

    it "prepends its own incflags before any pre-existing ones" do
      expect(@context.incflags).to eql "-I/foo\\ bar/v8/include -I/usr/include -I/usr/local/include"
    end

    it "prepends the locations of any libv8 objects on the the ldflags" do
      expect(@context.ldflags).to eql "/foo\\ bar/v8/out.gn/libv8/obj/libv8_monolith.a -lobjc -lpthread"
    end
  end
end
