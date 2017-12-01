module AnyStyle
  describe "Redis Dictionary Adapter" do
    let(:dict) { Dictionary.create(adapter: :redis) }

    it "is a Dictionary" do
      expect(dict).to be_a(Dictionary)
      expect(dict).to be_instance_of(Dictionary::Redis)
    end
  end if defined?(::Redis)
end
