module AnyStyle
  describe Finder do

    let(:f) { Finder.new }
    let(:doc) {
      Document.parse <<~EOS
        A1.  REFERENCES
           \t\r\t
        A1.  REFERENCES

          Matsumoto (2006) Ruby: The Programming Language. O'Reilly.
      EOS
    }

    describe "#prepare" do
      it 'expands a dataset' do
        f.prepare(doc)

        expect(doc[0].observations.map(&:to_s)).to eq(%w{
          11 15 10 7 1 1 3 title + + Lu Lu 2 6 6 1 numeric 1 5 0 0 0 5 F = - - - - F first only
        })
        expect(doc[1].observations.map(&:to_s)).to eq(%w{
          0 0 0 0 0 0 0 none + + none none 0 0 0 0 none 0 0 0 0 0 0 F = - - - - F 2 only
        })
        expect(doc[3].observations.map(&:to_s)).to eq(%w{
          0 0 0 0 0 0 0 none + + none none 0 0 0 0 none 0 0 0 0 0 0 F = - - - - F 6 only
        })
        expect(doc[4].observations.map(&:to_s)).to eq(%w{
          42 60 2 7 1 1 10 none = = Lu P 7 6 7 0 alpha 1 0 4 1 3 4 T + + - - - F last only
        })
      end
    end
  end
end
