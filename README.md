AnyStyle
========
[![Build Status](https://travis-ci.org/inukshuk/anystyle.svg?branch=master)](https://travis-ci.org/inukshuk/anystyle)
[![Coverage Status](https://coveralls.io/repos/github/inukshuk/anystyle/badge.svg?branch=master)](https://coveralls.io/github/inukshuk/anystyle?branch=master)

AnyStyle is a very fast and smart parser for academic references. It
was originally inspired by [ParsCit](http://aye.comp.nus.edu.sg/parsCit/)
and [FreeCite](http://freecite.library.brown.edu/); AnyStyle uses machine
learning algorithms and aims to make it easy to train the model with data
that is relevant to your parsing needs.



Using AnyStyle CLI
------------------

    $ [sudo] gem install anystyle-cli
    $ anystyle --help


Web Application and Web Service
-------------------------------
AnyStyle is available as a web-application and service at
[anystyle.io](https://anystyle.io). Please note that the
web service is currently based on the legacy
[0.x branch](https://github.com/inukshuk/anystyle/tree/0.x).


Using AnyStyle in Ruby
----------------------

    $ [sudo] gem install anystyle


Reference Parsing
-----------------

Document Parsing
----------------

Training
--------

Dictionary Adapters
-------------------
During the statistical analysis of reference strings, AnyStyle relies
on a large feature dictionary; by default, AnyStyle creates a persistent
Ruby Hash in the folder of the `anystyle-data` Gem. This uses up about
2MB of disk space and keeps the entire dictionary in memory. If you prefer
a smaller memory footprint, you can alternatively use AnyStyle's GDBM
dictionary. GDBM bindings are part of the Ruby standard library and are
supported on all platforms, but you may have to install GDBM on your
platform before installing Ruby.

If you do not want to use the the persistent Ruyb Hash nor the GBDM
bindings, you can store your dictionary in memory (not recommended) or
use a Redis. The best way to change the default dictionary adapter is by
adjusting AnyStyle's default configuration (when using the default parser
instances you must set the default before using the parser):

    AnyStyle::Dictionary.defaults[:adapter] = :ruby
    #-> Use a persistent Ruby hash;
    #-> slower start-up than GDBM but no extra dependency

    AnyStyle::Dictionary.defaults[:adapter] = :hash
    #-> Use in-memory dictionary; slow start-up but uses no space on disk

    require 'anystyle/dictionary/gdbm'
    AnyStyle::Dictionary.defaults[:adapter] = :gdbm

To use Redis, install the `redis` and `redis/namespace` (optional) Gems
and configure AnyStyle to use the Redis adapter:

    AnyStyle::Dictionary.defaults[:adapter] = :redis

    # Adjust the Redis-specifi configuration
    require 'anystyle/dictionary/redis'
    AnyStyle::Dictionary::Redis.defaults[:host] = 'localhost'
    AnyStyle::Dictionary::Redis.defaults[:port] = 6379

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
