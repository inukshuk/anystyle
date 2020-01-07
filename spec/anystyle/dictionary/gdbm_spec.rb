require 'fileutils'

begin
  require 'gdbm'
  require 'tmpdir'

  module AnyStyle
    describe "GDBM Dictionary Adapter" do
      let(:tmpdir) { Dir.mktmpdir }

      let(:dict) {
        Dictionary.create({
          adapter: :gdbm,
          path: File.join(tmpdir, 'test.db')
        })
      }

      after(:each) {
        dict.close
        FileUtils.remove_entry tmpdir
      }

      it "is a Dictionary" do
        expect(dict).to be_a(Dictionary)
        expect(dict).to be_instance_of(Dictionary::GDBM)
      end

      it "can be opened" do
        expect { dict.open }.to change { dict.open? }
        expect(File.exists?(dict.options[:path])).to be true
      end
    end
  end
rescue LoadError
  # ignore
end
