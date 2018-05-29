module AnyStyle
  describe Normalizer::Names do
    let(:n) { Normalizer::Names.new }

    let(:item) {{
      author: [names(:derrida)]
    }}

    it "resolves repeaters" do
      expect(
        n.normalize({ author: ['-----.,'] }, prev: [n.normalize(item)])[:author][0]
      ).to include(family: 'Derrida')
    end
  end
end
