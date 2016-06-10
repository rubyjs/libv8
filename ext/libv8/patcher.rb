module Libv8
  module Patcher
    PATCH_DIRECTORY = File.expand_path '../../../patches', __FILE__

    module_function

    def patch!
      File.open(".applied_patches", File::RDWR|File::CREAT) do |f|
        available_patches = Dir.glob(File.join(PATCH_DIRECTORY, '*.patch')).sort
        applied_patches = f.readlines.map(&:chomp)

        (available_patches - applied_patches).each do |patch|
          puts "Applying #{patch}"
          `patch -p1 -N < #{patch}`
          fail "failed to apply patch #{patch}" unless $?.success?
          f.puts patch
        end
      end
    end
  end
end
