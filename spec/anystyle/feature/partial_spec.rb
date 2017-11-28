module Anystyle
  describe "Partial Feature" do

    require 'anystyle/feature'
    require 'anystyle/feature/partial'

    let(:f) { Feature::Partial.new }
    let(:r) { Feature::Partial.new reverse: true }

    it "elicits substring sequences" do
      expect(f.elicit('England')).to eq(%w{ E En Eng Engl })
      expect(r.elicit('England')).to eq(%w{ d nd and land })
    end
  end
end
