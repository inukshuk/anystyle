module AnyStyle
  describe "Publisher Normalizer" do
    let(:n) { Normalizer::Publisher.new }
    let(:item) {{ author: [names(:poe)] }}

    it "replaces author publisher" do
      expect(
        n.normalize(item.merge(publisher: ['Author']))
      ).to include(publisher: [item[:author][0]])
    end
  end
end
