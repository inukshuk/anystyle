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
          { others: true }
        ]

        expect(n('Plath, L.C., Asgaard, G., ... Botros, N.')).to eq(authors)
        expect(n('Plath, L.C., Asgaard, G., … Botros, N.')).to eq(authors)
      end

      [
        ['J Doe', [{ family: 'Doe', given: 'J.' }]],
        ['Doe, J', [{ family: 'Doe', given: 'J.' }]],
        ['JE Doe', [{ family: 'Doe', given: 'J.E.' }]],
        ['Doe, JE', [{ family: 'Doe', given: 'J.E.' }]],
        ['Dendle MT, Sacchettini JC, Kelly JW', [
          { family: 'Dendle', given: 'M.T.' },
          { family: 'Sacchettini', given: 'J.C.' },
          { family: 'Kelly', given: 'J.W.' }
        ]],
        ['Bouchard J-P.', [{ family: 'Bouchard', given: 'J.-P.' }]],
        ['Edgar A. Poe; Herman Melville', [
          { family: 'Poe', given: 'Edgar A.' },
          { family: 'Melville', given: 'Herman' }
        ]],
        ['Poe, Edgar A., Melville, Herman', [
          { family: 'Poe', given: 'Edgar A.' },
          { family: 'Melville', given: 'Herman' }
        ]],
        ['Aeschlimann Magnin, E.', [{ family: 'Aeschlimann Magnin', given: 'E.' }]],
        ['Yang, Q., Mudambi, R., & Meyer, K. E.', [
          { family: 'Yang', given: 'Q.' },
          { family: 'Mudambi', given: 'R.' },
          { family: 'Meyer', given: 'K.E.' }
        ]]
      ].each do |input, output|
        it "tokenizes #{input.inspect}" do
          expect(n(input)).to eq(output)
        end
      end

      it "tokenizes editors" do
         expect(n('In D. Knuth (ed.)')).to eq([{ family: 'Knuth', given: 'D.' }])
         expect(n('In: D. Knuth (ed.)')).to eq([{ family: 'Knuth', given: 'D.' }])
         expect(n('in: D. Knuth ed.')).to eq([{ family: 'Knuth', given: 'D.' }])
         expect(n('in D. Knuth (ed)')).to eq([{ family: 'Knuth', given: 'D.' }])
      end
    end
  end
end
