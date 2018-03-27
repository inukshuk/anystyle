module AnyStyle
  describe Finder do

    let(:f) { Finder.new }
    let(:doc) {
      Document.parse <<~EOS
        A1. REFERENES
           \t\r\t

        Matsumoto (2006) Ruby: The Programming Language. O'Reilly.
      EOS
    }

    describe "#prepare" do
      it 'expands a dataset' do
        f.prepare(doc)

        expect(doc[0].observations.map(&:to_s)).to eq(%w{
          10 13 10 8 1 1 2 Lu Lu 2 1 0 0 0 0 F = - - - - first only
        })
        expect(doc[1].observations.map(&:to_s)).to eq(%w{
          0 0 0 0 0 0 0 none none 0 0 0 0 0 0 F = - - - - 3 only
        })
        expect(doc[2].observations.map(&:to_s)).to eq(%w{
          0 0 0 0 0 0 0 none none 0 0 0 0 0 0 F = - - - - 5 only
        })
      end
    end
  end
end
