module AnyStyle
  describe Document do
    let(:doc) { Document.new }
    let(:phd) { Document.open(fixture_path 'phd.txt') }

    describe 'pages' do
      it 'returns an array of pages' do
        expect(phd.pages.length).to eq(84)
        expect(phd.pages[42]).to be_a(Document::Page)
        expect(phd.pages[42].width).to eq(87)
      end
    end

    describe 'join_refs?' do
      it 'decides whether or not to join two reference strings' do
        fixture('ref-join.yml').each do |f|
          unless f['pending']
            expect(
              doc.join_refs?(f['a'], f['b'], f['delta'], f['indent'])
            ).to eq(f['join']), "Expected #{f['a'].inspect} and #{f['b']} #{f['join'] ? '' : 'not '} to join"
          end
        end
      end
    end
  end
end
