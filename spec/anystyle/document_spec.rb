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
        a = 'Anderson, Benedict R. Imagined Communities: Reflections on the Origin and Spread'
        b = 'of Nationalism. Rev. ed. London and New York: Verso, 1991.'
        expect(doc.join_refs?(a, b, 0, true)).to eq(true)

        a = 'Baepler, Paul Michel. White Slaves, African Masters: An Anthology of American'
        b = 'Barbary Captivity. Chicago: U of Chicago P, 1999.'
        expect(doc.join_refs?(a, b, 0, true)).to eq(true)

        a = 'O’Callaghan, Sean. The Slave Trade Today. New York: Crown Publishers, 1962.'
        b = 'Reiss, Timothy J. “Mapping Identities: Literature, Nationalism, Colonialism”.'
        expect(doc.join_refs?(a, b, 0, false)).to eq(false)
      end
    end
  end
end
