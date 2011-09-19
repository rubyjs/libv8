##libv8

A gem for distributing the v8 runtime libraries and headers in both source and binary form.

### Why?

The goal of libv8 is two fold: provide a binary gem containing the a pre-compiled libv8.a for as many
platforms as possible while at the same time supporting for an automated compilation for all others.

Not only does this drastically reduce gem install times, but it also reduces dependencies on the local
machine receiving the gem. It also opens the door for supporting Windows.

### Do I Get a Binary?

That depends on your platform. Right now, we support the following platforms.

* x86_64-darwin10.7.0
* x86_64-linux
* x86-linux

> **Note**: Gentoo amd64 users may need to tweak their environment. see [issue 8](/fractaloop/libv8/issues/8)

If you don't see your platform on this list, first, make sure that it installs from source, and second
talk to us about setting up a binary distro for you.


### What if I can't install from source?


If you can fix the [Makefile](https://github.com/fractaloop/libv8/blob/master/lib/libv8/Makefile) so that it correctly compiles for your platform, we'll pull it right in!

To get the source, these commands will get you started:

    git clone git@github.com:fractaloop/libv8
    cd libv8
    git submodule update --init
    bundle install
    bundle exec rake compile


### About

This project spun off of [therubyracer](http://github.com/cowboyd/therubyracer) which depends on having
a specific version of v8 to compile and run against. However, actually delivering that version 
reliably to all the different platforms proved to be a challenge to say the least.

We got tired of waiting 5 minutes for v8 to compile every time we installed that gem.

### License

(The MIT License)

Copyright (c) 2009,2010 Logan Lowell

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