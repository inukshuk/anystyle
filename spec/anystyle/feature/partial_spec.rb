module Anystyle
  describe "Sequence Feature" do

    require 'anystyle/feature'
    require 'anystyle/feature/sequence'

    let(:f) { Feature::Sequence.new }
    let(:r) { Feature::Sequence.new reverse: true }

    it "elicits substring sequences" do
      expect(f.elicit('England')).to eq(%w{ E En Eng Engl })
      expect(r.elicit('England')).to eq(%w{ d nd and land })
    end
  end
end
