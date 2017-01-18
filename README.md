`pry-debundle` allows you to require gems that are not in your `Gemfile` when inspecting
programs that are run with Bundler.

Usage
=====

Use the `pry` command, or `binding.pry` as normal. Watch how you can require any gem, even if it's not in your `Gemfile` and celebrate! Avoid getting confused by that fact when trying to debug `'require'` statements.


Installation
============

Add `pry` and `pry-debundle` to the Gemfile. These are both required, and have few (if
any) ill effects for developers who don't wish to use them.

```ruby
group :development do
  gem 'pry'
  gem 'pry-debundle'
  # other development gems everyone needs go here.
end
```

If you need to install these gems without buy-in from the rest of your team (sad panda)
there are instructions under Personal Installation.


Long-winded Explanation
=======================

Bundler is an awesome gem that gives you a good degree of confidence that "if it works in
development, it works in production". It can do this by being vicious about gem
dependencies: if it's not in the `Gemfile`, it's not getting required. It also ensures
that everyone's development environment is identical, no more does "it works on my
machine" cut it as an excuse.

There are circumstances when this dogmatic dedication to duty can get in the way. In
particular all good developers have set up their development environment very personally.
Obviously, it's not important that my local tools work in production, and it's positively
bad for productivity if everyone is forced to have an identicial development setup.

So how do you reconcile these two points of view: "it should work the same everywhere",
and "it should be ideal for me"?

The obvious answer is to compromise; mostly "it should work the same everywhere", but when
I'm actively working on it (i.e. I have my `Pry` open) "it should be ideal for me".

To this end, `pry-debundle` will do nothing (I mean absolutely nothing) until you start
pry. At that point, the chains locking you into the Bundler jail are hacked asunder, and
immediately your precious pry plugins load, and all of those random gems you've
collected will be available to `require` as normal.

Before you rush off to try this, a word of warning: you will waste debugging time because
of this. Why? Because running a `require 'ampex'` inside Pry works, but running a `require
'ampex'` outside Pry doesn't. "XOMGWTF? Ohhhh! GAH!!" I hear your future self cry as you
forget this warning, and then painfully recall it.

As the adage goes: "No gain, without pain".


Personal Installation
=====================

So let's say everyone on your team wants to use pry, but some of them are too scared to
use `pry-debundle`. This is pretty easy to support. Just add Pry to the Gemfile as
before, and then copy the implementation of the gem into your ~/.pryrc

```ruby
group :development do
  gem 'pry'
  # other development gems everyone needs go here.
end
```

```bash
curl https://raw.githubusercontent.com/ConradIrwin/pry-debundle/master/lib/pry-debundle.rb >> ~/.pryrc
```

If you can't even persuade people to allow you to add Pry to the Gemfile, then you can
write a little wrapper script to run your app to make sure Pry is loaded before Bundler,
and install `pry-debundle` into your ~/.pryrc as above.

Meta-fu
=======

Licensed under the MIT license (see `LICENSE.MIT`). Bug reports and pull requests are
welcome.

It's possible that Bundler will solve this issue themselves, in which case I expect to
deprecate this gem. See https://github.com/carlhuda/bundler/issues/183 for some
discussion.
