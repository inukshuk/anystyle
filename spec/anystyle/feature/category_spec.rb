module AnyStyle
  describe "Category Feature" do
    let(:f) { Feature::Category.new }

    it "observe last character category" do
      expect(f.observe('UNO')).to eq(:upper)
      expect(f.observe('x64')).to eq(:number)
      expect(f.observe('Letter')).to eq(:lower)
      expect(f.observe('A.B.')).to eq('.')
      expect(f.observe('(2009)')).to eq(')')
      expect(f.observe('(2009);')).to eq(';')
    end
  end
end
