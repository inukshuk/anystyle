module AnyStyle
  describe Normalizer::Names do
    def n(author, **opts)
      Normalizer::Names.new.normalize({ author: [author] }, **opts)[:author]
    end

    it "resolves repeaters" do
      prev = [{ author: [{ literal: 'X' }]}]
      expect(n('-----.,')[0]).to include(literal: '-----.')
      expect(n('-----.,', prev: prev)[0]).to include(literal: 'X')
    end

    describe "Name Parsing" do
      let(:doe) {{ family: 'Doe', given: 'J.' }}
      let(:poe) {{ family: 'Poe', given: 'Edgar A.' }}
      let(:melville) {{ family: 'Melville', given: 'Herman' }}
      let(:knuth) {{ family: 'Knuth', given: 'D.' }}
      let(:others) {{ others: true }}

      it "supports mixed lists" do
        expect(n('A, B, C, D')).to eq([
          { family: 'A', given: 'B.' },
          { family: 'C', given: 'D.' }
        ])

        expect(n('A, B, C')).to eq([
          { family: 'A', given: 'B.' },
          { given: 'C.' }
        ])

        expect(n('Aa Bb, C.')).to eq([
          { family: 'Aa Bb', given: 'C.' }
        ])

        expect(n('Aa Bb, Cc Dd, and E F G')).to eq([
          { family: 'Bb', given: 'Aa' },
          { family: 'Dd', given: 'Cc' },
          { family: 'G', given: 'E.F.' },
        ])

        expect(n('I. F. Senturk, S. Yilmaz and K. Akkay')).to eql([
          { family: 'Senturk', given: 'I.F.' },
          { family: 'Yilmaz', given: 'S.' },
          { family: 'Akkay', given: 'K.' }
        ])
      end

      it "tokenizes 'A. B'" do
        expect(n('A. B')[0]).to eq({ family: 'B', given: 'A.' })
        expect(n('A B')[0]).to eq({ family: 'B', given: 'A.' })
        expect(n('B, A')[0]).to eq({ family: 'B', given: 'A.' })
      end

      it "tokenizes 'A. B jr'" do
        expect(n('B, A, jr')[0]).to eq({ family: 'B', given: 'A.', suffix: 'jr' })
        expect(n('B, jr, A.')[0]).to eq({ family: 'B', given: 'A.', suffix: 'jr' })
      end

      it "tokenizes 'Plath, L.C., Asgaard, G., ... Botros, N.'" do
        authors = [
          { family: 'Plath', given: 'L.C.' },
          { family: 'Asgaard', given: 'G.' },
          { family: 'Botros', given: 'N.' },
          others
        ]

        expect(n('Plath, L.C., Asgaard, G., ... Botros, N.')).to eq(authors)
        expect(n('Plath, L.C., Asgaard, G., … Botros, N.')).to eq(authors)
      end

      it "tokenizes real names" do
        [
          ['J Doe', [doe]],
          ['Doe, J', [doe]],
          ['JE Doe', [{ family: 'Doe', given: 'J.E.' }]],
          ['Doe, JE', [{ family: 'Doe', given: 'J.E.' }]],
          ['Dendle MT, Sacchettini JC, Kelly JW', [
            { family: 'Dendle', given: 'M.T.' },
            { family: 'Sacchettini', given: 'J.C.' },
            { family: 'Kelly', given: 'J.W.' }
          ]],
          ['Bouchard J-P.', [{ family: 'Bouchard', given: 'J.-P.' }]],
          ['Edgar A. Poe; Herman Melville', [poe, melville]],
          ['Poe, Edgar A., Melville, Herman', [poe, melville]],
          ['Aeschlimann Magnin, E.', [{ family: 'Aeschlimann Magnin', given: 'E.' }]],
          ['Yang, Q., Mudambi, R., & Meyer, K. E.', [
            { family: 'Yang', given: 'Q.' },
            { family: 'Mudambi', given: 'R.' },
            { family: 'Meyer', given: 'K.E.' }
          ]]
        ].each do |input, output|
            expect(n(input)).to eq(output)
          end
      end

      describe "Editor Patterns" do
        it "tokenizes editors" do
           expect(n('In D. Knuth (ed.)')).to eq([knuth])
           expect(n('In: D. Knuth (ed.)')).to eq([knuth])
           expect(n('in: D. Knuth ed.')).to eq([knuth])
           expect(n('in D. Knuth (ed)')).to eq([knuth])
        end

        it "does not strip 'ed' etc. from names" do
           expect(n('In Edward Wood')).to eq([{ family: 'Wood', given: 'Edward' }])
           expect(n('ed. by Alfred Wood')).to eq([{ family: 'Wood', given: 'Alfred' }])
           expect(n('edited by A. Wooded')).to eq([{ family: 'Wooded', given: 'A.' }])
           expect(n('édited par A. Wooded')).to eq([{ family: 'Wooded', given: 'A.' }])
           expect(n('Hrsg Wood, H. (Hg.)')).to eq([{ family: 'Hrsg Wood', given: 'H.' }])
        end
      end

      describe 'Translator Patterns' do
        it "strips translation patterns" do
          expect(n('Translated by J Doe')).to eq([doe])
          expect(n('Trans. by J Doe')).to eq([doe])
          expect(n('Transl. J Doe')).to eq([doe])
          expect(n('übersetzt von J Doe')).to eq([doe])
          expect(n('übers. v. J Doe')).to eq([doe])
          expect(n('Übersetzung v. J Doe')).to eq([doe])
          expect(n('In einer Übersetzung von J Doe')).to eq([doe])
          expect(n('Trad. J Doe')).to eq([doe])
          expect(n('traduit par J Doe')).to eq([doe])
        end
      end

      it "strips and resolves 'et al' / others" do
        expect(n('J Doe et al')).to eq([doe, others])
        expect(n('J Doe et al.')).to eq([doe, others])
        expect(n('J Doe u.a.')).to eq([doe, others])
        expect(n('J Doe u. a.')).to eq([doe, others])
        expect(n('J Doe and others')).to eq([doe, others])
        expect(n('J Doe & others')).to eq([doe, others])
        expect(n('J Doe et coll.')).to eq([doe, others])
        expect(n('J Doe ...')).to eq([doe, others])
      end
    end

    describe "Parsed Core Data" do
      before :all do
        @data = resource('parser/core.xml')
          .map { |item| item.values_at(*Normalizer::Names.keys) }
          .flatten
          .uniq
          .reject { |name| name.nil? || name[:other] }
      end

      let(:lit) { @data.select { |name| !name[:literal].nil? } }
      let(:nam) { @data.select { |name| name[:literal].nil? } }

      it "accepts more than 95% of names" do
        expect(nam.length.to_f / @data.length).to be > 0.95
      end
    end
  end
end
