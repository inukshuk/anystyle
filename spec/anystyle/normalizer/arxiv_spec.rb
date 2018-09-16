module AnyStyle
  describe "arXiv Normalizer" do
    let(:n) { Normalizer::ArXiv.new }

    it "extracts valid arXiv ids" do
      ({
        'Preprint, arXiv:1402.7034,' => { arxiv: ['1402.7034'] },
        '[arXiv:hepph/9905221].' => { arxiv: ['hepph/9905221'] }
      }).each do |(a, b)|
        expect(n.normalize(note: [a])).to include(b)
      end
    end
  end
end
