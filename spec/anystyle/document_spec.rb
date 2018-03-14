module AnyStyle
  describe Document do
    let(:phd) { Document.open(fixture_path 'phd.txt') }

    describe 'pages' do
      it 'returns an array of pages' do
        expect(phd.pages.length).to eq(83)
        expect(phd.pages[42]).to be_a(Document::Page)
        expect(phd.pages[42].width).to eq(87)
      end
    end
  end
end
