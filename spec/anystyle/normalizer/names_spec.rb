module AnyStyle
  describe Normalizer::Names do
    def n(author, **opts)
      Normalizer::Names.new.normalize({ author: [author] }, **opts)[:author]
    end

    it "resolves repeaters" do
      prev = [{ author: [{ literal: 'X' }]}]
      expect(n('-----.,')[0]).to include(literal: '-----.')
      expect(n('-----.,', prev: prev)[0]).to include(literal: 'X')
    end

    describe "Name Parsing" do
      it "supports mixed lists" do
        expect(n('I. F. Senturk, S. Yilmaz and K. Akkay')).to eql([
          { family: 'Senturk', given: 'I.F.' },
          { family: 'Yilmaz', given: 'S.' },
          { family: 'Akkay', given: 'K.' }
        ])
      end
    end
  end
end
