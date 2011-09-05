Anystyle-Parser
===============

Anystyle-Parser is a very fast and smart parser for academic references. It
is inspired by [ParsCit](http://aye.comp.nus.edu.sg/parsCit/) and
[FreeCite](http://freecite.library.brown.edu/); Anystyle-Parser is designed
for raw speed (it uses [wapiti](https://github.com/inukshuk/wapiti-ruby) based
conditional random fields and [Kyoto Cabinet](http://fallabs.com/kyotocabinet/)
as a key-value store), flexibility (it is easy to train the model with
data that is relevant to your parsing needs), and compatibility (Anystyle-Parser
exports to Ruby Hashes, BibTeX, or the CiteProc JSON format).

Installation
------------

    $ [sudo] gem install anystyle-parser

During the statistical analysis of reference strings, Anystyle-Parser relies
on a large feature dictionary; by default, Anystyle-Parser creates a 
[Kyoto Cabinet](http://fallabs.com/kyotocabinet/) file-based hash database
from the dictionary file that ships with the parser. If Kyoto Cabinet is
not installed on your system, Anystyle-Parser uses a simple Ruby Hash as a
fall-back; this Hash has to be re-created every time you load the parser
and takes up a lot of memory in your Ruby process; it is therefore strongly
recommended to install Kyoto Cabinet and the `kyotocabinet-ruby` gem.

    $ [sudo] gem install kyotocabinet-ruby 

The database file will be created the first time you access the dictionary;
note that you will need write permissions in the directory where the file
is to be created. You can change the Dictionary's default path in the
Dictrionary's options:

    Anystyle::Parser::Dictionary.instance.options[:path]


Usage
-----

### Parsing

You can access the main Anystyle-Parser instance at `Anystyle.parser`;
the `#parse` method is also available via `Anystyle.parse`. For more complex
requirements (e.g., if you need multiple Parser simultaneously) you can create
your own instances from the `Anystyle::Parser::Parser` class.

The two fundamental methods you need to know about in order to use
Anystyle-Parser are `#parse` and `#train` that both accept two arguments.

    Parser#parse(input, format = :hash)
    Parser#train(input, truncate = false)

`#parse` parses the passed-in input (either a filename, your reference strings,
or an array of your reference strings) and returns the parsed data in the
format specified as the second argument (supported formats include: *:hash*,
*:bibtex*, and *:citeproc*).

`#train` allows you to easily train the Parser's CRF model. The first argument
is either a filename or your data as a string; the format of training data
follows the XML-like syntax of the
[CORA dataset](http://www.cs.umass.edu/~mccallum/data/cora-ie.tar.gz); the
optional boolean argument lets you decide whether to train the existing
model or to create an entirely new one.

The following irb sessions illustrates some parser goodness:

    > require 'anystyle/parser'
    > Anystyle.parse 'Poe, Edgar A. Essays and Reviews. New York: Library of America, 1984.'
    => [{:author=>"Poe, Edgar A.", :title=>"Essays and Reviews", :location=>"New York", :publisher=>"Library of America", :year=>1984, :type=>:book}]
    > b = Anystyle.parse 'Dong C. Liu and Jorge Nocedal. 1989. On the limited memory BFGS method for large scale optimization. Mathematical Programming, 45:503–528.', :bibtex
    > b[0].author[1].given
    => "Jorge"
    > b[0].author.to_s
    => "Liu, Dong C. and Nocedal, Jorge"

### Unhappy with the results?

Citation references come in many forms, so, inevitably, you will find data
where Anystyle-Parser does not produce satisfying parsing results.

    > Anystyle.parse 'John Lafferty, Andrew McCallum, and Fernando Pereira. 2001. Conditional random fields: probabilistic models for segmenting and labeling sequence data. In Proceedings of the International Conference on Machine Learning, pages 282-289. Morgan Kaufmann, San Francisco, CA.'
    => [{:author=>"John Lafferty and Andrew McCallum and Fernando Pereira. 2001", :title=>"Conditional random fields: probabilistic models for segmenting and labeling sequence data", :booktitle=>"Proceedings of the International Conference on Machine Learning", :pages=>"282--289", :publisher=>"Morgan Kaufmann", :location=>"San Francisco, CA", :type=>:inproceedings}]

This result is not bad, but notice how the year was not picked up as a date
but interpreted as part of the author name. If you have such a problem
(particularly, if the problem applies to a range of your input data, e.g.,
data that follows a style that Anystyle-Parser was not trained to recognize),
you can teach Anystyle-Parser to recognize your format. The easiest way to
go about this is to create new file (e.g., 'training.txt'), copy and paste a
few references, and tag them for training. For example, a tagged version of
the input from the example above would look like this:

    <author> John Lafferty, Andrew McCallum, and Fernando Pereira. </author> <date> 2001. </date> <title> Conditional random fields: probabilistic models for segmenting and labeling sequence data. </title> <booktitle> In Proceedings of the International Conference on Machine Learning, </booktitle> <pages> pages 282–289. </pages> <publisher> Morgan Kaufmann, </publisher> <location> San Francisco, CA. </location>

Note that you can pick any tag names, but when working with Anystyle's model
you should use the same names used to to train the model. You can always ask
the Parser's model what names (labels) it knows about:

    > Anystyle.parser.model.labels
    => ["author", "booktitle", "container", "date", "edition", "editor", "institution", "journal", "location", "note", "pages", "publisher", "tech", "title", "unknown", "volume"]

Once you have tagged a few references that you want Anystyle-Parser to learn,
you can train the model as follows:

    > Anystyle.parser.train 'training.txt', false

By passing `true` as the second argument, you will discard Anystyle's default
model; the resulting model will be based entirely on your own data. By default
the new or altered model will not be saved, but you can do so at any time
by calling `Anystyle.parser.model.save` to save the model to the default file.
If you want to save the model to a different file, set the
`Anystyle.parser.model.path` attribute accordingly.

After teaching Anystyle-Parser with the tagged references, try to parse your
data again:

    > Anystyle.parse 'John Lafferty, Andrew McCallum, and Fernando Pereira. 2001. Conditional random fields: probabilistic models for segmenting and labeling sequence data. In Proceedings of the International Conference on Machine Learning, pages 282-289. Morgan Kaufmann, San Francisco, CA.'
    => [{:author=>"John Lafferty and Andrew McCallum and Fernando Pereira", :title=>"Conditional random fields: probabilistic models for segmenting and labeling sequence data", :booktitle=>"Proceedings of the International Conference on Machine Learning", :pages=>"282--289", :publisher=>"Morgan Kaufmann", :location=>"San Francisco, CA", :year=>2001, :type=>:inproceedings}]


Contributing
------------

The Anystyle-Parser source code is
[hosted on GitHub](http://github.com/inukshuk/anystyle-parser/).
You can check out a copy of the latest code using Git:

    $ git clone https://github.com/inukshuk/anystyle-parser.git

If you've found a bug or have a question, please open an issue on the
[Anystyle-Parser issue tracker](http://github.com/inukshuk/anystyle-parser/issues).
Or, for extra credit, clone the Anystyle-Parser repository, write a failing
example, fix the bug and submit a pull request.


License
-------

Copyright 2011 Sylvester Keil. All rights reserved.

Some of the code in Anystyle-Parser's post processing (normalizing) routines
was originally based on the source code of FreeCite and

Copyright 2008 Public Display Inc.

The CRF template is a modified version of ParsCit's original template

Copyright 2008, 2009, 2010, 2011 Min-Yen Kan,
Isaac G. Councill, C. Lee Giles, Minh-Thang Luong and Huy Nhat Hoang
Do.

Anystyle-Parser is distributed under a BSD-style license. See LICENSE for details.
