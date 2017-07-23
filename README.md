# libv8
[![Gem Version](https://badge.fury.io/rb/libv8.svg)](https://badge.fury.io/rb/libv8)
[![Number of downloads](https://ruby-gem-downloads-badge.herokuapp.com/libv8?type=total)](https://rubygems.org/gems/libv8)
[![Build Status](https://travis-ci.org/cowboyd/libv8.svg?branch=master)](https://travis-ci.org/cowboyd/libv8)
[![Join the chat at https://gitter.im/cowboyd/therubyracer](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cowboyd/therubyracer?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Code Triagers Badge](https://www.codetriage.com/cowboyd/libv8/badges/users.svg)](https://www.codetriage.com/cowboyd/libv8)

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

* x86_64-darwin-16
* x86_64-darwin-15
* x86_64-darwin-14
* x86_64-linux
* x86-linux
* x86_64-freebsd-10
* x86_64-freebsd-11

If you don't see your platform on this list, first, make sure that it
installs from source, and second talk to us about setting up a binary
distro for you.

#### Note on ~~OS X~~ macOS binaries

If you're installing libv8 on a macOS system that is present in the list above,
and despite that, RubyGems insists on downloading a source version and compiling
it, check the output of `ruby -e 'puts Gem::Platform.local'`. If it does not
reflect the current version of your OS, recompile Ruby.

The platform gets hardcoded in Ruby during compilation and if you've updated
your OS since you've compiled Ruby, it does not represent correctly your current
platform which leads to RubyGems trying to download a platform-specific gem for
the older version of your OS.

### Versioning

Versions of the libv8 gem track the version of V8 itself, adding its
own point release after the main V8 version. So libv8 `5.0.71.35.5`
and `5.0.71.35.14` both correspond to V8 version `5.0.71.35`. Another
way to think about it would be that `5.0.71.35.14` is the 14th release
of the libv8 rubygem based on V8 version `5.0.71.35`

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

So for example, `5.0.71.35.3` contains all the binary distributions,
while `5.0.71.35.2` is the exact same code, but contain only a
source-based distribution

> This step release system is a workaround to carlhuda/bundler#1537

##### Use with different standard C libraries

The Linux binary versions of this gem are linked against the most used standard
library - glibc. Currently rubygems has no mechanism to differentiate
platform-specific gems by standard library so we have no way of distributing
different binaries for different standard libraries.

What this means is that if you're running a distro that does not use glibc
(like Alpine Linux), you'll have to use a source version of the gem.

Also, at the time of writing this, the Ruby version in Alpine's package
repositories has been patched to not look to download binary versions of gems at
all.

### Requirements

Building the V8 library from source imposes the following requirements:

*  A compiler that supports C++11 (such as GCC 4.8 and above or clang,
preferably 3.5 and above)
*  GNU Make
*  Python 2

### Using a git version

If you want to use the latest unstable version of the gem you can do
so by specifying the git repo as a gem source. Just make sure you add
the following to your `Gemfile`:

```Ruby
gem "libv8", github: "cowboyd/libv8", submodules: true
```

You can find more info on using a git repo as a gem source in
[Bundler's documentation](http://bundler.io/v1.3/git.html).

### What if I can't install from source?

If you can fix V8's build system so that it correctly compiles for your
platform, we'll pull it right in!

To get the source, these commands will get you started:

    git clone --recursive git://github.com/cowboyd/libv8.git
    cd libv8
    bundle install
    bundle exec rake compile

### Bring your own V8

*This is a great way to ensure that the builds of all gems that depend on libv8
fail. Please see the Gotchas section below and use the follwing instructions
only if you know what you're doing. If you're resorting to this because the
build of the gem is failing on your system or because there's no
platform-specific gem for your platform, please open up an issue.*

Because libv8 is the interface for the V8 engine used by several gems, you may
need to use libv8, even if you have V8 installed already. If you wish to use
your own V8 installation, rather than have it built for you, use the
`--with-system-v8` option.

Using RubyGems:

    gem install libv8 -- --with-system-v8

Using Bundler (in your Gemfile):

    bundle config build.libv8 --with-system-v8

#### Gotchas

Please note that if you intend to run your own V8, you must install
both V8 *and its headers* (found in libv8-dev for Debian-based distros).

Also, keep in mind that V8's API does not tend to be stable and in case you're
using your local version of V8 you *need* to **make sure that the the gems that
depend on libv8 are compatible with the API of the version of V8 present on your
system**. Otherwise those gems' builds *will* fail. Ideally you want the same
version of V8 as the one packaged in the installed version of the gem. See the
Versioning section for more information.

### Bring your own compiler

You can specify a compiler of your choice by either setting the `CXX`
environment variable before compilation, or by adding the
`--with-cxx=<compiler>` option to the bundle configuration:

    bundle config build.libv8 --with-cxx=clang++

### About

This project spun off of
[therubyracer](http://github.com/cowboyd/therubyracer) which depends
on having a specific version of V8 to compile and run against.
However, actually delivering that version reliably to all the
different platforms proved to be a challenge to say the least.

We got tired of waiting 5 minutes for V8 to compile every time we
installed that gem.

### Sponsored by

<a href="http://frontside.io">![The Frontside](/thefrontside.png)</a>
<a href="https://www.scaleway.com">![Scaleway](/scaleway.png)</a>

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
