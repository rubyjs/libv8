module Libv8
  module Patcher
    PATCH_DIRECTORY = File.expand_path '../../../patches', __FILE__

    module_function

    def patches(*additional_directories)
      Dir.glob(File.join 'patches', '*.patch')
    end

    def patch!(*additional_directories)
      File.open(".applied_patches", File::RDWR|File::CREAT) do |f|
        available_patches = patches
        applied_patches = f.readlines.map(&:chomp)

        (available_patches - applied_patches).each do |patch|
          `patch -p1 -N < #{patch}`
          f.puts patch
        end
      end
    end
  end
end
