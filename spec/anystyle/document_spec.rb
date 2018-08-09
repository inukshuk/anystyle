module AnyStyle
  describe Document do
    let(:doc) { Document.new }
    let(:phd) { Document.open(fixture_path 'phd.txt') }
    let(:ref) { Finder.new.label(phd)[0].references }

    describe 'pages' do
      it 'returns an array of pages' do
        expect(phd.pages.length).to eq(84)
        expect(phd.pages[42]).to be_a(Page)
        expect(phd.pages[42].width).to eq(87)
      end
    end

    describe 'references' do
      it 'return an array of strings' do
        expect(ref[0]).to start_with('Ackerberg')
        expect(ref[-1]).to start_with('(2008)')
        expect(ref.length).to eq(43)
      end
    end
  end
end
