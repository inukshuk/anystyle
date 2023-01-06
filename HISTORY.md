1.4.0 / 2023-01-06
==================
* Removed deprectate string taint checking (@bbonamin).
* `AnyStyle::Parser#parse` will no longer automatically open local files.
  Please call `Wapiti::Dataset.open` explicitly if you relied on this.

1.3.6 / 2019-12-02
==================
* Updated parser model.

1.3.3 / 2019-01-10
==================
* Improved support of German-language journal conventions (@a-fent)
* Updated parser model.

1.3.0 / 2018-09-18
==================
* Updated and improved normalizers and CSL format.
* Improved Chinese reference tokenization.
* Added option to customizee pdftotext path.
* Improved Finder reference line joining.
* Improved Finder model; training sets.
* Improved Parser model; training sets.

1.2.1 / 2018-08-17
==================
* Added check and train commands to CLI.
* Added --no-solo and --crop flags to find command.
* Added reference block normalizer.
* Added script detection normalizer.
* Improved Finder reference line joining.
* Improved Finder model; training sets.

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
