AnyStyle
========
[![Build Status](https://travis-ci.org/inukshuk/anystyle.svg?branch=master)](https://travis-ci.org/inukshuk/anystyle)
[![Coverage Status](https://coveralls.io/repos/github/inukshuk/anystyle/badge.svg?branch=master)](https://coveralls.io/github/inukshuk/anystyle?branch=master)

AnyStyle is a fast and smart parser of bibliographic references.
Originally inspired by [parsCit][] and [FreeCite][],
AnyStyle uses machine learning algorithms
and aims to make it easy to train models
with data that's relevant to you.


Using AnyStyle on the command line
----------------------------------
    $ [sudo] gem install anystyle-cli
    $ anystyle --help
    $ anystyle help find
    $ anystyle help parse

See [anystyle-cli][] for more details.


Using AnyStyle in Ruby
----------------------
Install the `anystyle` gem.

    $ [sudo] gem install anystyle

Now you can use the static Parser and Finder instances
by calling the `AnyStyle.parse` or `AnyStyle.find` methods.
For example:

```ruby
require 'anystyle'

pp AnyStyle.parse 'Derrida, J. (1967). L’écriture et la différence (1 éd.). Paris: Éditions du Seuil.'
#-> [{
#  :author=>[{:family=>"Derrida", :given=>"J."}],
#  :date=>["1967"],
#  :title=>["L’écriture et la différence"],
#  :edition=>["1"],
#  :location=>["Paris"],
#  :publisher=>["Éditions du Seuil"],
#  :language=>"fr",
#  :scripts=>["Common", "Latin"],
#  :type=>"book"
#}]
```

You can also create your own
`AnyStyle::Parser` or `AnyStyle::Finder` with custom options.


Using AnyStyle on the web
-------------------------
AnyStyle is available at [anystyle.io][].

The web application is [open source][]
and you're welcome to host your own instance!

[anystyle-cli]: https://github.com/inukshuk/anystyle-cli
[anystyle.io]: https://anystyle.io
[open source]: https://github.com/inukshuk/anystyle.io
[parsCit]: http://aye.comp.nus.edu.sg/parsCit/
[FreeCite]: http://freecite.library.brown.edu/


Improving results for your data
===============================
Training
--------
You can train custom Finder and Parser models.
To do this, you need to prepare your own data sets for training.
You can create your own data from scratch
or build on AnyStyle's default sets.
The default parser model uses the [core][] data set.
And though the finder model sources aren't available in their entirety,
due to copyright restrictions,
you can find several [tagged documents][] here.

When you have compiled a data set for training,
you will be ready to create your own model:

    $ anystyle train training-data.xml custom.mod

This will save your new model as `custom.mod`.
To use your model instead of AnyStyle's default,
use the `-P` or `--parser-model` flag and, respectively,
`-F` or `--finder-model` to use a custom finder model.
For instance, the command below
will parse a file `bib.txt` with the custom model
and print the result to STDOUT in JSON format:

    $ anystyle -P custom.mod -f json parse bib.txt -

When training your own models, it's good practice
to check their quality using a second data set.
For example, to check your custom model
using AnyStyle's manually curated [gold][] data set:

    $ anystyle -P x.mod check ./res/parser/gold.xml
    Checking gold.xml.................   1 seq  0.06%   3 tok  0.01%  3s

This command prints sequence and token error rates.
Here, sequence errors are the number of references
tagged differently by the parser
as compared to the curated input;
the number of token errors
is the total number of words in these references.
In the example above, one reference was wrong
(out of 1,700 at the time),
because a total of three words had a different tag.

When working with training data,
it's a good idea to use the `Wapiti::Dataset` API in Ruby:
it supports standard set operators
and makes it easy to combine or compare data sets.

[core]: https://github.com/inukshuk/anystyle/blob/master/res/parser/core.xml
[gold]: https://github.com/inukshuk/anystyle/blob/master/res/parser/gold.xml
[tagged documents]: https://github.com/inukshuk/anystyle/blob/master/res/finder


Natural Languages used in AnyStyle
----------------------------------
The [core][] data set contains the manually marked-up references
which comprise AnyStyle's default parser model.
If your references include non-English documents,
the distribution of natural languages in this corpus is relevant.

| Language                | n   |
|-------------------------|-----|
| ENGLISH                 | 965 |
| FRENCH                  | 54  |
| GERMAN                  | 26  |
| ITALIAN                 | 11  |
| Others                  | 9   |
|                         |     |
| Not reliably determined | 449 |
| (but mainly English)    |     |

(Measured using [cld][] and AnyStyle version 1.3.13)

There is a strong prevalence of English-language documents with the
conventions used in English-language bibliographies,
with some representation of other European languages.
The languages used reflect those used in scientific publishing
as well as the maintainers' competencies.
If you are working with documents in languages other than English,
you might consider training the model with some examples
in the relevant languages.

AnyStyle works with references written in any Latin script,
including most European languages,
languages such as Indonesian and Malaysian,
as well as romanized Arabic, Chinese and Japanese.
It also supports non-Latin alphabets such as Cyrillic,
although no examples of these appear in the default training sets.
Languages written in syllabaries or complex symbols
which don't use white space to separate tokens
aren't compatible with AnyStyle's approach:
this includes Chinese, Japanese, Arabic, and Indian languages. 

[cld]: https://github.com/jtoy/cld


Dictionary Adapters
-------------------
During the statistical analysis of reference strings,
AnyStyle relies on a large feature dictionary;
by default, AnyStyle creates a persistent Ruby hash
in the folder of the `anystyle-data` Gem.
This uses up about 2MB of disk space
and keeps the entire dictionary in memory.
If you prefer a smaller memory footprint,
you can use AnyStyle's GDBM dictionary.
GDBM bindings are part of the Ruby standard library
and supported on all platforms,
though you may need to install GDBM before installing Ruby.

If you don't want to use the persistent Ruby hash nor GBDM,
you can store your dictionary in memory or use a Redis.
The best way to change the default dictionary adapter
is by adjusting AnyStyle's default configuration
(when using the static parser instances
you must set the default before using the parser):

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


About AnyStyle
==============
Contributing
------------
The AnyStyle source code is hosted on [GitHub][].
You can check out a copy of the latest code using Git:

    $ git clone https://github.com/inukshuk/anystyle.git

If you've found a bug or have a question,
please [report the issue][] or,
for extra credit, clone the AnyStyle repository,
write a failing example, fix the bug and submit a pull request.

[GitHub]: https://github.com/inukshuk/anystyle/
[report the issue]: https://github.com/inukshuk/anystyle/issues


Credits
-------
AnyStyle is a volunteer effort and you're encourage to join!
Over the years the main contributors have been:

* [Alex Fenton](https://github.com/a-fent)
* [Sylvester Keil](https://github.com/inukshuk)
* [Johannes Krtek](https://github.com/flachware)
* [Ilja Srna](https://github.com/namyra)


License
-------
Copyright 2011-2023 Sylvester Keil. All rights reserved.

AnyStyle is distributed under a BSD-style license.
See [LICENSE](./LICENSE) for details.
