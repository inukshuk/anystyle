module AnyStyle
  describe "Category Feature" do
    let(:f) { Feature::Category.new }

    it "observe last character category" do
      expect(f.observe('UNO')).to eq([:Lu, :Lu])
      expect(f.observe('x64')).to eq([:Ll, :N])
      expect(f.observe('Letter')).to eq([:Lu, :Ll])
      expect(f.observe('A.B.')).to eq([:Lu, :P])
      expect(f.observe('(2009)')).to eq([:Ps, :Pe])
      expect(f.observe('(2009);')).to eq([:Ps, :P])
    end
  end
end
