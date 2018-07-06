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
pre-compiled libv8_monolith.a for as many platforms as possible while at the
same time supporting for an automated compilation for all others.

Not only does this drastically reduce gem install times, but it also
reduces dependencies on the local machine receiving the gem. It also
opens the door for supporting Windows.

### Do I get a binary?

That depends on your platform. Right now, we support the following
platforms.

* x86_64-darwin-17
* x86_64-darwin-16
* x86_64-darwin-15
* x86_64-darwin-14
* x86_64-linux
* x86-linux

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

### Requirements

Building the V8 library from source imposes the following requirements:

* An x86/x86_64 CPU. See [#261](https://github.com/cowboyd/libv8/issues/261) for ARM state.
* Linux with glibc or macOS. See
  [#259](https://github.com/cowboyd/libv8/issues/259),
  [#253](https://github.com/cowboyd/libv8/issues/253) and
  [#217](https://github.com/cowboyd/libv8/issues/217) for state of other
  platforms.
* Python 2

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
