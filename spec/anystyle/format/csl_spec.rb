module AnyStyle
  describe Format::CSL do
    let(:ap) { Parser.new }

    let(:refs) {[
      'Derrida, J. (c.1967). L’écriture et la différence (1 éd.). Paris: Éditions du Seuil.',
      'Perec, Georges. A Void. London: The Harvill Press, 1995. p.108.',
    ]}

    it 'Converts parse results to CSL items' do
      items = ap.parse(refs, format: 'csl')
      expect(items).to be_a(::Array)
      expect(items.size).to eq(refs.length)

      expect(items[0][:type]).to eq('book')
      expect(items[0][:author][0][:family]).to eq('Derrida')
      expect(items[0][:title]).to eq('L’écriture et la différence')
      expect(items[0][:issued]).to eq('1967~')
      expect(items[1][:issued]).to eq('1995')
    end

    it 'Supports CiteProc date syntax' do
      items = ap.parse(refs, format: 'csl', date_format: 'citeproc')
      expect(items[0][:issued]).to eq({ :'date-parts' => [[1967]], :circa => true })
      expect(items[1][:issued]).to eq({ :'date-parts' => [[1995]] })
    end

    it 'Converts Core Data to CSL without errors' do
      items = resource('parser/core.xml', format: 'csl')
      expect(items).to be_a(::Array)
      expect(items.size).to be > 1000
    end
  end
end
