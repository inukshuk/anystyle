1.1.0 / 2018-07-11
==================
* Improved Parser model; training sets.
* Improved Finder model; training sets.
* Volume normalizer: extract page numbers and dates.
* Fixed errors in Names and Publisher normalizer.
* Added Unicode normalizer to default normalizers.

1.0.1 / 2018-06-06
==================
* Initial 1.0 release! This release is not backwards compatible to the
  0.x branch. The new release uses the `AnyStyle` module and can be
  installed using the `anystyle` Gem. The 0.x branch used the `Anystyle`
  module and can still be installed using the `anystyle-parser` Gem but
  will not be maintained any longer.
* Includes vastly improved parser model and training sets.
* Based on updated `wapiti-ruby` which builds on Linux, macOS, and
  Windows platforms (thanks @a-fent and @WouterJeuris).
* Flexible normalizer architecture (normalizers can be skipped individually).
* Improved feature architecture.
* Improved input/output via Wapiti::Dataset.
* New default dictionary adapter (thanks @a-fent).
* New GDBM dictionary adapter.
* Use real XML for training sets.
* Experimental *Finder* component for PDF and text document analysis.
* Dictionary data moved to `anystyle-data` Gem.
* New CLI tool `anystyle-cli`.
* Dropped support for Ruby 2.2 and older.


[Older Releases](https://github.com/inukshuk/anystyle/blob/0.x/HISTORY.md)
