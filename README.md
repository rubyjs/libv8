
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


If you don't see your platform on this list, first, make sure that it installs from source, and second
talk to us about seeting up a binary distro for you.


### What if I can't install from source?


If you can fix the [Makefile](https://github.com/fractaloop/libv8/blob/master/lib/libv8/Makefile) so that it correctly compiles for your platform, we'll pull it right in!

{FIXME: Add instructions about how to compile v8 for your platform}

### About

This project spun off of [therubyracer](http://github.com/cowboyd/therubyracer) which depends on having
a specific version of v8 to compile and run against. However, actually delivering that version 
reliably to all the different platforms proved to be a challenge to say the least.

We got tired of waiting 5 minutes for v8 to compile every time we installed that gem.

### Develop

git clone git@github.com:fractaloop/v8
git submodule update --init
bundle exec rake compile
