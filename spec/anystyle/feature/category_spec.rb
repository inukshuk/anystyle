module AnyStyle
  describe "Category Feature" do
    let(:f) { Feature::Category.new }

    it "elicit last character category" do
      expect(f.elicit('UNO')).to eq(:upper)
      expect(f.elicit('x64')).to eq(:number)
      expect(f.elicit('Letter')).to eq(:lower)
      expect(f.elicit('A.B.')).to eq('.')
      expect(f.elicit('(2009)')).to eq(')')
      expect(f.elicit('(2009);')).to eq(';')
    end
  end
end
