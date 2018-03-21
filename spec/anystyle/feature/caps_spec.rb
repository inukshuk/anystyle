module AnyStyle
  describe "Caps Feature" do
    let(:f) { Feature::Caps.new }

    it "classifies the initial capitalization type" do
      expect(f.observe(nil, alpha: 'F')).to eq(:single)
      expect(f.observe(nil, alpha: 'Foo')).to eq(:initial)
      expect(f.observe(nil, alpha: 'FOO')).to eq(:caps)
      expect(f.observe(nil, alpha: 'foo')).to eq(:lower)
      expect(f.observe(nil, alpha: 'foo')).to eq(:lower)
      expect(f.observe(nil, alpha: '42F')).to eq(:other)
      expect(f.observe(nil, alpha: '')).to eq(:other)
    end
  end
end
