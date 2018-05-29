module AnyStyle
  describe Normalizer::Brackets do
    let(:n) { Normalizer::Brackets.new }

    it "removes brackets" do
      expect(
         n.normalize({
           'citation-number': ['[XI.]'],
           note: ['[Also see XY.]']
         })
      ).to include({
        'citation-number': ['XI.'],
        note: ['Also see XY.']
      })
    end
  end
end
