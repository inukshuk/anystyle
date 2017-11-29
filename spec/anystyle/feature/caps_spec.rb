module AnyStyle
  describe "Caps Feature" do
    let(:f) { Feature::Caps.new }

    it "classifies the initial capitalization type" do
      expect(f.elicit(nil, 'F')).to eq(:single)
      expect(f.elicit(nil, 'Foo')).to eq(:initial)
      expect(f.elicit(nil, 'FOO')).to eq(:caps)
      expect(f.elicit(nil, 'foo')).to eq(:lower)
      expect(f.elicit(nil, 'foo')).to eq(:lower)
      expect(f.elicit(nil, '42F')).to eq(:other)
      expect(f.elicit(nil, '')).to eq(:other)
    end
  end
end
