require 'fileutils'

module AnyStyle
  describe "LMDB Dictionary Adapter" do
    let(:dict) {
      Dictionary.create({
        adapter: :lmdb,
        path: Dir.mktmpdir
      })
    }

    after(:each) {
      dict.close
      FileUtils.remove_entry dict.path
    }

    it "is a Dictionary" do
      expect(dict).to be_a(Dictionary)
      expect(dict).to be_instance_of(Dictionary::LMDB)
    end

    it "can be opened" do
      expect(-> { dict.open }).to change { dict.open? }
    end
  end
end
