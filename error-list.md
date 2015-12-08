C:\Users\ghoal\workspace\project\libv8>bundle exec rake compile 
ruby ext/libv8/extconf.rb
creating Makefile
HEAD is now at 2f0efde.. Version 3.16.14
Using existing [svn-remote "svn"]
HEAD is now at f7bc250.. Make gyp/win32 compatible with upstream ninja.
Compiling v8 for x64
Using python 2.7.10
Using compiler: c:\devkit\mingw\bin\g++.EXE<GCC version 4.7.2>
bash: C:/Program: No such file or directory
make[1]: Entering directory '/c/Users/ghoal/workspace/project/libv8/vendor/v8/out'
make[1]: **** No rule to make target '../build\all.gyp', needed by 'Makefile.x64'. Stop.
make[1]: Leaving directory '/c/Users/ghoal/workspace/project/libv8/vendor/v8/out'
make[1]: *** [x64].release] Error 2
C:/Users/ghoal/workspace/project/libv8/location.rb:36:in 'block in verify_installation!' : libv8 did not install properly, expected binary v8 archive ' 
C:/Users/ghoal/workspace/project/libv8/vendor/v8/out/x64.release/obj.target/tools/gyp/libv8_base.a' to exist, but it was not
found <Libv8::Location:Vendor::ArchiveNotFound>
	from C:/Users/ghoal/workspace/project/libv8/ext/libv8/location.rb:35:in 'each'
	from
C:/Users/ghoal/workspace/project/libv8/ext/libv8/location.rb:35:in 'verify_installation!'
	from
C:/Users/ghoal/workspace/project/libv8/ext/libv8/location.rb:35:in 'install!'
	from ext/libv8/extconf.rb:7:in '<main>'
rake aborted!
Command failed with status <1>: [ruby ext/libv8/extconf.rb...]
C:/Users/ghoal/workspace/project/libv8/Rakefile:25:in 'block in <top <required>>'
	Tasks: TOP => compile
<See full trace by running task with --trace>

C:\Users\ghoal\workspace\project\libv8>