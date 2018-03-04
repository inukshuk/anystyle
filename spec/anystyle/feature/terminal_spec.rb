module AnyStyle
  describe "Terminal Feature" do
    let(:f) { Feature::Terminal.new }

    it "classifies the terminal type" do
      expect(f.observe('City.”')).to eq(:strong)
      expect(f.observe('City”.')).to eq(:strong)
      expect(f.observe('')).to eq(:none)
    end
  end
end

