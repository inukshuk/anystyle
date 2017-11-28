module Anystyle
  describe "Affix Feature" do
    let(:f) { Feature::Affix.new }
    let(:r) { Feature::Affix.new suffix: true }

    it "elicits partial strings" do
      expect(f.elicit('England')).to eq(%w{ E En Eng Engl })
      expect(r.elicit('England')).to eq(%w{ d nd and land })
    end
  end
end
