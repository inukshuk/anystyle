module AnyStyle
  describe "Caps Feature" do
    let(:f) { Feature::Caps.new }

    it "classifies the initial capitalization type" do
      expect(f.observe(nil, 'F')).to eq(:single)
      expect(f.observe(nil, 'Foo')).to eq(:initial)
      expect(f.observe(nil, 'FOO')).to eq(:caps)
      expect(f.observe(nil, 'foo')).to eq(:lower)
      expect(f.observe(nil, 'foo')).to eq(:lower)
      expect(f.observe(nil, '42F')).to eq(:other)
      expect(f.observe(nil, '')).to eq(:other)
    end
  end
end
