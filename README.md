AnyStyle
========
[![Build Status](https://travis-ci.org/inukshuk/anystyle.svg?branch=master)](https://travis-ci.org/inukshuk/anystyle)
[![Coverage Status](https://coveralls.io/repos/github/inukshuk/anystyle/badge.svg?branch=master)](https://coveralls.io/github/inukshuk/anystyle?branch=master)

AnyStyle is a very fast and smart parser for academic references. It
is inspired by [ParsCit](http://aye.comp.nus.edu.sg/parsCit/) and
[FreeCite](http://freecite.library.brown.edu/); AnyStyle uses machine
learning algorithms ([wapiti](https://github.com/inukshuk/wapiti-ruby))
and GDBM or [Redis](http://redis.io) as a key-value store, and is
designed to make it easy to train the model with data that is relevant
to your parsing needs.

Web Application and Web Service
-------------------------------
AnyStyle is available as a web-application and service at
[anystyle.io](https://anystyle.io).

Installation
------------

    $ [sudo] gem install anystyle

During the statistical analysis of reference strings, AnyStyle relies
on a large feature dictionary; by default, AnyStyle creates a GDBM
database file in the folder of the `anystyle-data` Gem. GDBM bindings
are part of the Ruby standard library and are supported on all platforms,
but you may have to install GDBM on your platform before installing Ruby.

If you do not want to use the GBDM bindings, you can store your dictionary
in memory (not recommended) or use a Redis. The best way to change the
default dictionary adapter is by adjusting AnyStyle's default configuration
before using the parser:

    AnyStyle::Dictionary.defaults[:adapter] = :hash
    #-> Use in-memory dictionary; slow but easy to setup

To use Redis, install the `redis` and `redis/namespace` (optional) Gems
and configure AnyStyle to use the Redis adapter:

    AnyStyle::Dictionary.defaults[:adapter] = :redis

    # Adjust the Redis-specifi configuration
    require 'anystyle/dictionary/redis'
    AnyStyle::Dictionary::Redis.defaults[:host] = 'localhost'
    AnyStyle::Dictionary::Redis.defaults[:port] = 6379

Reference Parsing
-----------------

Document Parsing
----------------

Training
--------

Contributing
------------
The AnyStyle source code is
[hosted on GitHub](https://github.com/inukshuk/anystyle/).
You can check out a copy of the latest code using Git:

    $ git clone https://github.com/inukshuk/anystyle.git

If you've found a bug or have a question, please open an issue on the
[AnyStyle issue tracker](http://github.com/inukshuk/anystyle/issues).
Or, for extra credit, clone the AnyStyle repository, write a failing
example, fix the bug and submit a pull request.

License
-------
Copyright 2011-2018 Sylvester Keil. All rights reserved.

AnyStyle is distributed under a BSD-style license.
See LICENSE for details.
