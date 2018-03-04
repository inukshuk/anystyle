# -*- encoding: utf-8 -*-

module AnyStyle
  describe Parser do

    describe "#prepare" do
      it 'returns expanded dataset' do
        expect(subject.prepare('Hello, world!').to_a).to eq([[
          'Hello, hello Lu P H He Hel Hell , o, lo, llo, initial none F F F F none 0 other none weak F',
          'world! world Ll P w wo wor worl ! d! ld! rld! lower none T F T T none 50 other none weak F'
        ]])
      end

      context 'when marking the input as being tagged' do
        let(:input) {
          %{<author>A. Cau, R. Kuiper, and W.-P. de Roever.</author><title>Formalising Dijkstra's development strategy within Stark's formalism. </title> <editor> In C. B. Jones, R. C. Shaw, and T. Denvir, editors, </editor> <container-title> Proc. 5th. BCS-FACS Refinement Workshop, </container-title> <date> 1992. </date>}
        }

        pending 'returns an array of expanded and labelled token sequences for a tagged string' do
          expect(subject.prepare(input, tagged: true)[0].map(&:label)).to eq(
            %w{ author author author author author author author author title title title title title title title editor editor editor editor editor editor editor editor editor editor editor container-title container-title container-title container-title container-title date }
          )
        end

        pending 'returns an array of expanded and labelled :unknown token sequences for an untagged input' do
          expect(subject.prepare('hello, world!', tagged: true)[0].map(&:label)).to eq([nil, nil])
        end

        #pending 'converts xml entitites' do
        #  expect(subject.prepare("<note>&gt;&gt; &amp; foo</note>", true)[0].map { |t| t[/\S+/] }).to eq(%w{ >> & foo })
        #end
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

        pending 'recognizes trained references' do
          subject.learn Wapiti::Dataset.new dps[0, 1]
          expect(subject.parse(dps[0].to_s, format: :wapiti)[0]).to eq(dps[0])
        end

        pending 'recognizes trained references when learnt in one go' do
          subject.learn dps

          dps.each do |d|
            expect(subject.parse(strip_tags(d), :tags)[0]).to eq(d)
          end
        end

        pending 'recognizes trained references when learnt separately' do
          dps.each do |d|
            subject.learn d
          end

          dps.each do |d|
            expect(subject.parse(strip_tags(d), :tags)[0]).to eq(d)
          end
        end
      end

      describe "the default model" do
      end
    end
  end
end
