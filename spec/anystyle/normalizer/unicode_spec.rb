module AnyStyle
  describe Normalizer::Unicode do
    let(:n) { Normalizer::Unicode.new }

    it "removes ligatures" do
      expect(
         n.normalize({
           title: ['An ﬃ module.']
         })
      ).to include({
        title: ['An ffi module.']
      })
    end
  end
end
