### v6.7.288.46.0, v6.7.288.46.1 - 2017-07-06

* Update upstream v8 version to 6.7.288.46 (https://github.com/cowboyd/libv8/pull/258)
  Due to the change in V8's build system this causes several major changes until
  we're able to find a way to reimplement the necessary functionality. The changes
  are listed below.
* Remove the option to specify --with-cxx. For now V8 is built with the
  toolchain provided by the build system (https://github.com/cowboyd/libv8/issues/260)
* Remove the option to specify --with-system-v8. It was making it too easy for
  the user to shot themself in the foot.
* Drop ARM support. The V8 build system is not working natively on ARM and for
  some reason crosscompilation produces X86 binaries
  (https://github.com/cowboyd/libv8/issues/261)
* Drop FreeBSD support. Chromium's depot_tools do not support FreeBSD at this
  point. (https://github.com/cowboyd/libv8/issues/253)

### v6.3.292.48.0, v6.3.292.48.1 - 2017-12-20

* Update upstream v8 version to 6.3.292.48
* Add a fix for https://bugs.chromium.org/p/v8/issues/detail?id=6933

### v6.2.414.42.0, v6.2.414.42.1 - 2017-12-13

* Update upstream v8 version to 6.2.414.42

### v6.0.286.54.2, v6.0.286.54.3 - 2017-10-25

* Fix regression when building from source gem #246
* Fix regression when linking against the library
  https://github.com/discourse/mini_racer/issues/65#issuecomment-331765949

### v6.0.286.54.0, v6.0.286.54.1 - 2017-08-25

* Update upstream v8 version to 6.0.286.54
* V8 source is no longer pulled using the fetch command from depot_tools but is
  instead added as a submodule in the current tree
* Hooks are no longer ran after syncing V8's upstream dependencies
* Reordered libraries in accordance with the V8 wiki

### v5.9.211.38.0, v5.9.211.38.1 - 2017-07-26

* Update upstream v8 version to 5.9.211.38

### v5.7.492.65.0, v5.7.492.65.1 - 2017-07-18

* Update upstream v8 version to 5.7.492.65
* Stop using the bundled toolchain to compile. (Fixes Alpine Linux compilation
  failures) #227
* Set GYP_DEFINES when fetching/syncing upstream source #233
* Add ARMv6 architecture detection #234, #235
* Add an Alpine Linux Vagrant VM for testing purposes #221

### v5.3.332.38.4, v5.3.332.38.5 - 2016-02-27

* Fix architecture detection for armv7 #226
* Dramatically reduce the binary size on macOS (thanks @aviat)
* Allow passing of GYP_DEFINES as an environment variable

### v5.3.332.38.2, v5.3.332.38.3 - 2016-11-21

* Add a macOS Sierra binary gem

### v5.3.332.38.0, v5.3.332.38.1 - 2016-09-07

* Update upstream v8 version to 5.3.332.38

### 5.2.361.43.0, 5.2.361.43.1 - 2016-06-26:

* Compare compiler versions part by part as integers instead of using string
  comparison on the whole version string #154 (thanks @ltk)
* Update upstream v8 to version 5.2.361.43 and refresh the patch set

### 5.1.281.67.0, 5.1.281.67.1 - 2016-06-26:

* Update upstream v8 version to 5.1.281.67 to address #219

### 5.1.281.59.0, 5.1.281.59.1 - 2016-06-15:

* Update upstream v8 version to 5.1.281.59
* Make sure the patch set is applied in the correct order

### 5.0.71.48.4, 5.0.71.48.5 - 2016-05-13:

* Enable the -fPIC flag for ARM

### 5.0.71.48.2, 5.0.71.48.3 - 2016-05-13:

* Upgrade upstream v8 version to 5.0.71.45
* Remove all workarounds for building v8 3.16 with newer compilers

### 3.16.14.14, 3.16.14.15 - 2016-04-28:

* Enhance compiler version detection and architecture detection #212
* Introduce darwin13-15 binary building #211
* Disable errors on warning for OS X #210
* Improve --with-system-v8 error message #200
* Fix the check for git-svn #199
