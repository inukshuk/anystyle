# -*- encoding: utf-8 -*-

module Anystyle::Parser
  describe Parser do

    it { should_not be nil }

    describe "#tokenize" do
      it "returns [] when given an empty string" do
        expect(subject.tokenize('')).to eq([])
      end

      it "takes a single line and returns an array of token sequences" do
        expect(subject.tokenize('hello, world!')).to eq([%w{ hello, world! }])
      end

      it "tokenizes volume/page-range exception" do
        expect(subject.tokenize('hello:world! http://abc.com 3:45 3:1-2 23:1 45(3):23–7')).to eq([%w{ hello:world! http://abc.com 3: 45 3: 1-2 23: 1 45(3): 23–7}])
      end

      it "takes two lines and returns an array of token sequences" do
        expect(subject.tokenize("hello, world!\ngoodbye!")).to eq([%w{ hello, world! }, %w{ goodbye! }])
      end

      context "when passing a string marked as tagged" do
        it "returns [] when given an empty string" do
          expect(subject.tokenize('', true)).to eq([])
        end

        it "returns an array of :unknown token sequences when given an untagged single line" do
          expect(subject.tokenize('hello, world!', true)).to eq([[['hello,', :unknown], ['world!', :unknown]]])
        end

        it "returns an array of :unknown token sequences when given two untagged lines" do
          expect(subject.tokenize("hello,\nworld!", true)).to eq([[['hello,', :unknown]], [['world!', :unknown]]])
        end

        it "returns an array of token/tag pair for each line when given a single tagged string" do
          expect(subject.tokenize('<a>hello</a>', true)).to eq([[['hello', :a]]])
        end

        it "returns an array of token/tag pair for each line when given a string with multiple tags" do
          expect(subject.tokenize('<a>hello world</a> <b> !</b>', true)).to eq([[['hello',:a], ['world', :a], ['!', :b]]])
        end

        it "raises an argument error if the string contains mismatched tags" do
          expect { subject.tokenize('<a> hello </b>', true) }.to raise_error(ArgumentError)
          expect { subject.tokenize('<a> hello <b> world </a>', true) }.to raise_error(ArgumentError)
        end
      end

    end

    describe "#prepare" do
      it 'returns an array of expanded token sequences' do
        expect(subject.prepare('hello, world!')).to eq([['hello, , h he hel hell , o, lo, llo, hello other none 0 no-male no-female no-surname no-month no-place no-publisher no-journal no-editors 0 internal other none', 'world! ! w wo wor worl ! d! ld! rld! world other none 36 no-male no-female surname no-month no-place publisher no-journal no-editors 5 terminal other none']])
      end

      context 'when marking the input as being tagged' do
        let(:input) { %{<author> A. Cau, R. Kuiper, and W.-P. de Roever. </author> <title> Formalising Dijkstra's development strategy within Stark's formalism. </title> <editor> In C. B. Jones, R. C. Shaw, and T. Denvir, editors, </editor> <booktitle> Proc. 5th. BCS-FACS Refinement Workshop, </booktitle> <date> 1992. </date>} }

        it 'returns an array of expaned and labelled token sequences for a tagged string' do
          expect(subject.prepare(input, true)[0].map { |t| t[/\S+$/] }).to eq(%w{ author author author author author author author author title title title title title title title editor editor editor editor editor editor editor editor editor editor editor booktitle booktitle booktitle booktitle booktitle date })
        end

        it 'returns an array of expanded and labelled :unknown token sequences for an untagged input' do
          expect(subject.prepare('hello, world!', true)[0].map { |t| t[/\S+$/] }).to eq(%w{ unknown unknown })
        end

        it 'converts xml entitites' do
          expect(subject.prepare("<note>&gt;&gt; &amp; foo</note>", true)[0].map { |t| t[/\S+/] }).to eq(%w{ >> & foo })
        end
      end
    end

    describe "#label" do
      let(:citation) { 'Perec, Georges. A Void. London: The Harvill Press, 1995. p.108.' }

      it 'returns an array of labelled segments' do
        expect(subject.label(citation)[0].map(&:first)).to eq([:author, :title, :location, :publisher, :date, :pages])
      end

      describe 'when passed more than one line' do
        it 'returns two arrays' do
          expect(subject.label("foo\nbar").size).to eq(2)
        end
      end

      describe 'when passed invalid input' do
        it 'returns an empty array for an empty string' do
          expect(subject.label('')).to eq([])
        end

        it 'returns an empty array for empty lines' do
          expect(subject.label("\n")).to eq([])
          expect(subject.label("\n ")).to eq([])
          expect(subject.label(" \n ")).to eq([])
          expect(subject.label(" \n")).to eq([])
        end

        it 'does not fail for unrecognizable input' do
          expect { subject.label("@misc{70213094902020,\n") }.not_to raise_error
          expect { subject.label("doi = {DOI:10.1503/jpn.100140}\n}\n") }.not_to raise_error
          expect { subject.label("\n doi ") }.not_to raise_error
        end
      end


    end

    describe "#parse" do
      let(:citation) { 'Perec, Georges. A Void. London: The Harvill Press, 1995. p.108.' }

      it 'returns a hash of label/segment pairs by default' do
        expect(subject.parse(citation)[0]).to eq({
          :author => 'Perec, Georges',
          :title => 'A Void',
          :location => 'London',
          :publisher => 'The Harvill Press',
          :date => '1995',
          :language => 'en',
          :pages => '108',
          :type => :book
        })
      end

      describe 'using output format "tags"' do
        it 'returns a tagged string' do
          expect(subject.parse(citation, :tags)[0]).to eq('<author>Perec, Georges.</author> <title>A Void.</title> <location>London:</location> <publisher>The Harvill Press,</publisher> <date>1995.</date> <pages>p.108.</pages>')
        end
      end

      it 'returns the label/token arrays for format "raw"' do
        expect(subject.parse(citation, :raw)[0][0]).to eq([:author, 'Perec,'])
      end

      it 'returns the token in original order for format "raw"' do
        expect(subject.parse(citation, :raw)[0].map(&:last).join(' ')).to eq(citation)

        difference = 'Derrida, J. (1967). L’écriture et la différence (1 éd.). Paris: Éditions du Seuil.'
        expect(subject.parse(difference, :raw)[0].map(&:last).join(' ')).to eq(difference)
      end

      it 'returns xml document for format "raw"' do
        expect(subject.parse(citation, :xml)).to eq('<?xml version="1.0" encoding="UTF-8"?><references><reference><author>Perec, Georges.</author><title>A Void.</title><location>London:</location><publisher>The Harvill Press,</publisher><date>1995.</date><pages>p.108.</pages></reference></references>')
      end
    end

    describe "#train" do
      let(:dps) { File.open(fixture_path('train_dps.txt'), 'r:UTF-8').read.split(/\n/) }

      describe "a pristine model" do
        before(:each) { subject.train '', true }

        it 'recognizes trained references' do
          subject.learn dps[0]
          expect(subject.parse(strip_tags(dps[0]), :tags)[0]).to eq(dps[0])
        end

        it 'recognizes trained references when learnt in one go' do
          subject.learn dps

          dps.each do |d|
            expect(subject.parse(strip_tags(d), :tags)[0]).to eq(d)
          end
        end

        it 'recognizes trained references when learnt separately' do
          pending

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
