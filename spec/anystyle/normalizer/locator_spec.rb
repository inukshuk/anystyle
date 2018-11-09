module AnyStyle
  describe "Locator Normalizer" do
    let(:n) { Normalizer::Locator.new }

    it "extracts valid DOIs" do
      ({
        'doi:10/aabbe' => { doi: ['10/aabbe'] },
        'doi:10/gckfx5' => { doi: ['10/gckfx5'] },
        'doi:10/abc' => { doi: ['10/abc'] },
        'doi:10.1002/mpr.33.' => { doi: ['10.1002/mpr.33.'] },
        'https://doi.org/10.1000/182' => { doi: ['10.1000/182'] }
      }).each do |(a, b)|
        expect(n.normalize(doi: [a])).to include(b)
      end
    end

    it "extracts valid DOIs in URLs" do
      ({
        'https://doi.org/10/aabbe' => { doi: ['10/aabbe'] },
        'https://doi.org/10.1000/182' => { doi: ['10.1000/182'] }
      }).each do |(a, b)|
        expect(n.normalize(url: [a])).to include(b)
      end
    end
  end
end
