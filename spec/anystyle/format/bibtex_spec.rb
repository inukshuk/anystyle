module AnyStyle
  describe Format::BibTeX do
    let(:ap) { Parser.new }

    let(:refs) {[
      'Derrida, J. (1967). L’écriture et la différence (1 éd.). Paris: Éditions du Seuil.'
    ]}

    it 'Converts parse results to BibTeX' do
      bib = ap.parse(refs, format: 'bibtex')
      expect(bib).to be_a(::BibTeX::Bibliography)
      expect(bib.size).to eq(refs.length)

      expect(bib[0].type).to eq(:book)
      expect(bib[0].author[0].family).to eq('Derrida')
      expect(bib[0].title).to eq('L’écriture et la différence')
      expect(bib[0].edition).to eq('1')
    end

    it 'Converts Core Data to BibTeX' do
      bib = resource('parser/core.xml', format: 'bibtex')
      expect(bib).to be_a(::BibTeX::Bibliography)
      expect(bib.size).to be > 900
    end
  end
end
