module Anystyle
  describe "Partial Feature" do
    let(:f) { Feature::Partial.new }
    let(:r) { Feature::Partial.new reverse: true }

    it "elicits partial strings" do
      expect(f.elicit('England')).to eq(%w{ E En Eng Engl })
      expect(r.elicit('England')).to eq(%w{ d nd and land })
    end
  end
end
