module CompilerHelpers
  VERSION_OUTPUTS = {
    :gcc => {
      "4.2.1-freebsd" => %Q{Using built-in specs.\nTarget: i386-undermydesk-freebsd\nConfigured with: FreeBSD/i386 system compiler\nThread model: posix\ngcc version 4.2.1 20070831 patched [FreeBSD]\n},
      "4.9.0" => %Q{Using built-in specs.\nCOLLECT_GCC=c++\nCOLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0/lto-wrapper\nTarget: x86_64-unknown-linux-gnu\nConfigured with: /build/gcc-multilib/src/gcc-4.9-20140604/configure --prefix=/usr --libdir=/usr/lib --libexecdir=/usr/lib --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=https://bugs.archlinux.org/ --enable-languages=c,c++,ada,fortran,go,lto,objc,obj-c++ --enable-shared --enable-threads=posix --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp --enable-gnu-unique-object --enable-linker-build-id --enable-cloog-backend=isl --disable-cloog-version-check --enable-lto --enable-plugin --enable-install-libiberty --with-linker-hash-style=gnu --enable-multilib --disable-werror --enable-checking=release\nThread model: posix\ngcc version 4.9.0 20140604 (prerelease) (GCC)\n}
    },
    :clang => {
      "3.0.9" => %Q{clang version 3.0.9 (tags/RELEASE_34/dot1-final)\nTarget: x86_64-unknown-linux-gnu\nThread model: posix\nFound candidate GCC installation: /usr/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/bin/../lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\nSelected GCC installation: /usr/bin/../lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\n},
      "3.3-freebsd" => %Q{FreeBSD clang version 3.3 (tags/RELEASE_33/final 183502) 20130610\nTarget: i386-unknown-freebsd9.2\nThread model: posix},
      "3.4.1" => %Q{clang version 3.4.1 (tags/RELEASE_34/dot1-final)\nTarget: x86_64-unknown-linux-gnu\nThread model: posix\nFound candidate GCC installation: /usr/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/bin/../lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.0\nFound candidate GCC installation: /usr/lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\nSelected GCC installation: /usr/bin/../lib64/gcc/x86_64-unknown-linux-gnu/4.9.0\n},
    },
    :apple_llvm => {
      '4.20' => %Q{Configured with: --prefix=/Applications/Xcode.app/Contents/Developer//usr --with-gxx-include-dir=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/usr/include/c++/4.2.1\nApple LLVM version 4.20 (clang-503.0.38) (based on LLVM 3.4svn)\nTarget: x86_64-apple-darwin14.0.0\nThread model: posix\n},
      '4.2' => %Q{Configured with: --prefix=/Applications/Xcode.app/Contents/Developer//usr --with-gxx-include-dir=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/usr/include/c++/4.2.1\nApple LLVM version 4.2 (clang-503.0.38) (based on LLVM 3.4svn)\nTarget: x86_64-apple-darwin14.0.0\nThread model: posix\n}
    }
  }

  def version_output_of(name, version)
    VERSION_OUTPUTS[name][version]
  end

  def success_status
    double :success? => true
  end

  def failure_status
    double :success? => false
  end

  def stub_shell_command(command, output, status)
    allow(Libv8::Compiler).to receive(:execute_command).with(command) do
      double :output => output, :status => status
    end
  end

  def stub_as_available(command, name, version)
    stub_shell_command "env LC_ALL=C LANG=C #{command} -v 2>&1", version_output_of(name, version), success_status
  end

  def stub_as_unavailable(command)
    stub_shell_command(/^env LC_ALL=C LANG=C #{Regexp.escape(command)}/, '', failure_status)
  end
end

RSpec.configure do |c|
  c.include CompilerHelpers
end
