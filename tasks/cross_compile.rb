arm_compilers = ['arm-linux-gnueabihf-g++', 'arm-unknown-linux-gnueabi-g++']

available = lambda { |name| system "which #{name} 2> /dev/null" }
have_hard_float = lambda { |compiler| `#{compiler} -v 2>&1`.include? '--with-float=hard' }

available_arm_compilers = arm_compilers.select(&available)
hard_float_arm_compilers = available_arm_compilers.select(&have_hard_float)

if hard_float_arm_compilers.any?
  desc 'Cross-compile for ARM (with hard float)'
  task 'compile:armhf' do
    ENV['CXX'] = hard_float_arm_compilers.last unless ENV['CXX']
    compile
  end

  desc "Build a binary gem for arm-linux-eabihf"
  task 'binary:armhf' => ['compile:armhf'] do
    build_binary_gem 'arm-linux-eabihf'
  end
end
