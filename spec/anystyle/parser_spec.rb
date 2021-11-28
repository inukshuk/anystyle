# -*- encoding: utf-8 -*-

module AnyStyle
  describe Parser do

    describe "#prepare" do
      it 'returns expanded dataset' do
        expect(subject.prepare('Hello, world!').to_a).to eq([[
          'Hello, hello Lu P H He , o, initial none F F F F none first other none weak F',
          'world! world Ll P w wo ! d! lower none T F T T none last other none weak F'
        ]])
      end
    end

    describe "#label" do
      let(:perec) {
        'Perec, Georges. A Void. London: The Harvill Press, 1995. p.108.'
      }

      it 'returns tagged dataset' do
        expect(subject.label(perec)[0].map(&:label).uniq).to eq(%w[
          author title location publisher date pages
        ])
      end

      describe 'when passed more than one line' do
        it 'returns two sequences' do
          expect(subject.label("foo\nbar").size).to eq(2)
        end
      end

      describe 'when passed invalid input' do
        it 'returns an empty array for an empty string' do
          expect(subject.label('')).to be_empty
        end

        it 'returns an empty array for empty lines' do
          expect(subject.label("\n")).to be_empty
          expect(subject.label("\n ")).to be_empty
          expect(subject.label(" \n")).to be_empty
          expect(subject.label("\n \n")).to be_empty
        end

        it 'does not fail for unrecognizable input' do
          expect { subject.label("@misc{70213094902020,\n") }.not_to raise_error
          expect { subject.label("\n doi ") }.not_to raise_error
        end
      end
    end

    describe "#parse" do
      let(:perec) {
        'Perec, Georges. A Void. London: The Harvill Press, 1995. p.108.'
      }

      let(:derrida) {
        'Derrida, J. (1967). L’écriture et la différence (1 éd.). Paris: Éditions du Seuil.'
      }

      it 'returns a hash of label/segment pairs by default' do
        expect(subject.parse(perec)[0]).to eq({
          author: [{ family: 'Perec', given: 'Georges' }],
          title: ['A Void'],
          location: ['London'],
          publisher: ['The Harvill Press'],
          date: ['1995'],
          pages: ['108'],
          language: 'en',
          scripts: ['Common', 'Latin'],
          type: 'book'
        })
      end

      it 'returns tagged dataset for wapiti format"' do
        dataset = subject.parse(perec, format: :wapiti)
        expect(dataset).to be_a(Wapiti::Dataset)
        expect(dataset[0][0].to_a(expanded: false)).to eq(['Perec,', 'author'])
      end

      it 'round-trips using wapiti format' do
        expect(subject.parse(perec, format: :wapiti).to_txt).to eq(perec)
        expect(subject.parse(derrida, format: :wapiti).to_txt).to eq(derrida)
      end

      it 'returns xml document for format "raw"' do
        expect(subject.parse(perec, format: :wapiti).to_xml.to_s).to eq(
          '<?xml version="1.0" encoding="UTF-8"?><dataset><sequence><author>Perec, Georges.</author><title>A Void.</title><location>London:</location><publisher>The Harvill Press,</publisher><date>1995.</date><pages>p.108.</pages></sequence></dataset>'
        )
      end
    end

    describe "#train" do
      let(:dps) {
        Wapiti::Dataset.open fixture_path('dps.xml')
      }

      describe "a pristine model" do
        before(:each) { subject.train '', truncate: true }

        it 'recognizes trained references' do
          subject.learn dps[0]
          expect(subject.label(dps[0])[0]).to eq(dps[0])
        end

        it 'recognizes trained references when learnt in one go' do
          subject.learn dps
          dps.each do |seq|
            expect(subject.label(seq)[0]).to eq(seq)
          end
        end

        pending 'recognizes trained references when learnt separately' do
          dps.each do |seq|
            subject.learn seq
          end
          dps.each do |seq|
            expect(subject.label(seq)[0]).to eq(seq)
          end
        end
      end
    end
    describe "Inheritance" do
      class ParserSubclass < AnyStyle::Parser
      end
      it 'Subclass can be initialized without own @defaults' do
        expect { ParserSubclass.new }.not_to raise_error
      end
    end
  end
end
