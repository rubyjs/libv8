arm_compilers = ['arm-linux-gnueabihf-g++', 'arm-unknown-linux-gnueabi-g++']

unavailable = lambda { |name| !system("which #{name} 2> /dev/null") }
no_hard_float = lambda { |compiler| `#{compiler} -v 2>&1` !~ /--with-float=hard/ }

available_arm_compilers = arm_compilers.delete_if(&unavailable)
hard_float_arm_compilers = available_arm_compilers.delete_if(&no_hard_float)

namespace :compile do
  if available_arm_compilers.any?
    if hard_float_arm_compilers.any?
      desc 'Cross-compile for ARM (with hard float)'
      task :armhf do
        ENV['CXX'] = hard_float_arm_compilers.last
        compile
      end
    end
  end
end
