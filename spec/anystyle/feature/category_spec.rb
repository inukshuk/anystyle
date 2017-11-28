module Anystyle
  describe "Category Feature" do
    let(:f) { Feature::Category.new }
    let(:r) { Feature::Partial.new reverse: true }

    it "elicit last character category" do
      expect(f.elicit('UNO')).to eq(:upper)
      expect(f.elicit('x64')).to eq(:numeric)
      expect(f.elicit('Letter')).to eq(:lower)
      expect(f.elicit('A.B.')).to eq('.')
    end
  end
end
