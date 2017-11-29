module AnyStyle
  describe "Affix Feature" do
    let(:f) { Feature::Affix.new }
    let(:r) { Feature::Affix.new suffix: true }
    let(:s) { Feature::Affix.new size: 2 }

    it "prefix series" do
      expect(f.elicit('England')).to eq(%w{ E En Eng Engl })
    end

    it "suffix series" do
      expect(r.elicit('England')).to eq(%w{ d nd and land })
    end

    it "custom size" do
      expect(s.elicit('England')).to eq(%w{ E En })
    end
  end
end
