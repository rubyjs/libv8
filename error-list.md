C:\Windows\System32\libv8>bundle exec rake compile
ruby ext/libv8/extconf.rb
creating Makefile
HEAD is now at 2f0efde... Version 3.16.14
HEAD is now at f7bc250... Make gyp/win32 compatible with upstream ninja.
In: creating symbolic link 'build/gyp' to 'C:/Windows/System32/libv8/vendor/gyp';
No such file or directory 
'patch' is not recognized as an internal or external command,
operable program or batch file.
C:/Windows/System32/libv8/ext/libv8/patcher.rb:51:in 'block <2 levels> in patch!':
failed to apply patch <RuntimeError>
		from C:/Windows/System32/libv8/ext/libv8/patcher.rb:49:in 'each'
	from 
C:/Windows/System32/libv8/ext/libv8/patcher.rb:49:in 'block in patch!'
	from 
C:/Windows/System32/libv8/ext/libv8/patcher.rb:45:in 'open'
	from 
C:/Windows/System32/libv8/ext/libv8/patcher.rb:45:in 'patch!'
	from 
c:/Windows/System32/libv8/ext/libv8/builder.rb:57:in 'block in build_libv8!'
	from 
C:/Windows/System32/libv8/ext/libv8/builder.rb:52:in 'chdir'
	from 
C:/Windows/System32/libv8/ext/libv8/builder.rb:52:in 'build_libv8'
	from 
C:/Windows/System32/libv8/ext/libv8/location.rb:24:in 'installl'
	from 
ext/libv8/extconf.rb:7:in '<main>'
rake aborted!
Command failed with status <1>: [ruby ext/libv8/extconf.rb...]
Windows/System32/libv8/Rakefile:25:in 'block in <top <required>>'
Tasks: Top = > compile
<See full trace by running task with --trace>
