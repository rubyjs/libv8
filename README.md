# libv8

A gem for distributing the v8 runtime libraries and headers in both
source and binary form.

### Why?

The goal of libv8 is two fold: provide a binary gem containing the a
pre-compiled libv8.a for as many platforms as possible while at the
same time supporting for an automated compilation for all others.

Not only does this drastically reduce gem install times, but it also
reduces dependencies on the local machine receiving the gem. It also
opens the door for supporting Windows.

### Do I get a binary?

That depends on your platform. Right now, we support the following
platforms.

* x86_64-darwin10.7.0
* x86_64-darwin-10
* x86_64-darwin-11
* x86_64-darwin-12
* x86_64-linux
* x86-linux
* arm-linux-gnueabihf
* amd64-freebsd-9

If you don't see your platform on this list, first, make sure that it
installs from source, and second talk to us about setting up a binary
distro for you.

### Versioning

Versions of the libv8 gem track the version of v8 itself, adding its
own point release after the main v8 version. So libv8 `3.11.8.5` and
`3.11.8.14` both correspond to v8 version `3.11.8`. Another way to
think about it would be that `3.11.8.14` is the 14th release of the
libv8 rubygem based on v8 version `3.11.8`

#### Source and Binary Releases

Starting with libv8 `3.11.8.0`, all even point releases contain
only a source-based distribution, while odd point releases contain both
a source-based distribution *and* binary distributions. However both
point releases correspond to the *exact* underlying code. The only
difference is the version number.

This way, the most recent version of the gem always has binary
distributions, but if, for whatever reason, you have problems with the
binaries, you can always "lock in" your dependency a single point version
down, forcing it to compile from source.

So for example, `3.15.12.3` contains all the binary distributions, while
`3.15.12.2` is the exact same code, but contain only a source-based
distribution

> This step release system is a workaround to carlhuda/bundler#1537

### What if I can't install from source?

If you can fix the "Makefile" so that it correctly compiles for your
platform, we'll pull it right in!

To get the source, these commands will get you started:

    git clone git://github.com/cowboyd/libv8.git
    cd libv8
    bundle install
    bundle exec rake checkout
    bundle exec rake compile

A binary gem can be produced by executing `bundle exec rake binary`.
Once the compilation is finished, the gem will be stored in the `pkg`
directory.

### Bring your own V8

Because libv8 is the interface for the V8 engine used by
[therubyracer](http://github.com/cowboyd/therubyracer), you may need
to use libv8, even if you have V8 installed already. If you wish to
use your own V8 installation, rather than have it built for you, use
the `--with-system-v8` option.

Using RubyGems:

    gem install libv8 -- --with-system-v8

Using Bundler (in your Gemfile):

    bundle config build.libv8 --with-system-v8

Please note that if you intend to run your own V8, you must install
both V8 *and its headers* (found in libv8-dev for Debian distros).

### Cross-compilation

Currently the libv8 gem supports cross-compilation for ARM and is
tested on the Raspberry Pi running with a hard float image.

To build a binary gem for the Pi, you will need to get yourself a
toolchain. The easiest way to do this is by following the
instructions [here](http://www.kitware.com/blog/home/post/426).

Once you have `g++` and `glib` that can produce an ARM binaries,
you only need to set the `TARGET` and `CXX` environment variables
and execute `bundle exec rake binary`. The target needs to match
the value of `RbConfig::CONFIG['target']` of the system you are
cross-compiling for.

Example for the Raspberry Pi with hfp:
```
TARGET=arm-linux-gnueabihf CXX=arm-unknown-linux-gnueabi-g++ rake binary
```

### About

This project spun off of
[therubyracer](http://github.com/cowboyd/therubyracer) which depends
on having a specific version of v8 to compile and run against.
However, actually delivering that version reliably to all the
different platforms proved to be a challenge to say the least.

We got tired of waiting 5 minutes for v8 to compile every time we
installed that gem.

### Sponsored by

<a href="http://thefrontside.net">![The Frontside](http://github.com/cowboyd/libv8/raw/master/thefrontside.png)</a>

### License

(The MIT License)

Copyright (c) 2009,2010 Charles Lowell

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.