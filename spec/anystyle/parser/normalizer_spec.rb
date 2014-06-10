# -*- encoding: utf-8 -*-

module Anystyle
  module Parser

    describe "Normalizer" do
      let(:n) { Normalizer.instance }

      describe "#tokenize_names" do

        it "tokenizes 'A B'" do
          expect(Normalizer.instance.normalize_names('A B')).to eq('B, A.')
        end

        it "tokenizes 'A, B'" do
          expect(Normalizer.instance.normalize_names('A, B')).to eq('A, B.')
        end

        it "tokenizes 'A, jr., Bbb'" do
          expect(Normalizer.instance.normalize_names('A, jr., B')).to eq('A, jr., B.')
        end

        it "tokenizes 'A, B, jr.'" do
          expect(Normalizer.instance.normalize_names('A, B, jr.')).to eq('A, jr., B.')
        end

        it "tokenizes 'A, B, C, D'" do
          expect(Normalizer.instance.normalize_names('A, B, C, D')).to eq('A, B. and C, D.')
        end

        it "tokenizes 'A, B, C'" do
          expect(Normalizer.instance.normalize_names('A, B, C')).to eq('A, B. and C.')
        end

        it "tokenizes 'Aa Bb, C.'" do
          expect(Normalizer.instance.normalize_names('Aa Bb, C.')).to eq('Aa Bb, C.')
        end

        it "tokenizes 'Plath, L.C., Asgaard, G., ... Botros, N.'" do
          expect(Normalizer.instance.normalize_names('Plath, L.C., Asgaard, G., ... Botros, N.')).to eq('Plath, L.C. and Asgaard, G. and Botros, N.')
          expect(Normalizer.instance.normalize_names('Plath, L.C., Asgaard, G., … Botros, N.')).to eq('Plath, L.C. and Asgaard, G. and Botros, N.')
        end

        it "tokenizes 'Aa Bb, Cc Dd, and E F G'" do
          expect(Normalizer.instance.normalize_names('Aa Bb, Cc Dd, and E F G')).to eq('Bb, Aa and Dd, Cc and G, E.F.')
        end

        [
          ['Poe, Edgar A.', 'Poe, Edgar A.'],
          ['Edgar A. Poe', 'Poe, Edgar A.'],
          ['J Doe', 'Doe, J.'],
          ['Doe, J', 'Doe, J.'],
          ['JE Doe', 'Doe, J.E.'],
          ['Doe, JE', 'Doe, J.E.'],
          ['Edgar A. Poe, Herman Melville', 'Poe, Edgar A. and Melville, Herman'],
          ['Edgar A. Poe; Herman Melville', 'Poe, Edgar A. and Melville, Herman'],
          ['Poe, Edgar A., Melville, Herman', 'Poe, Edgar A. and Melville, Herman'],
          ['Aeschlimann Magnin, E.', 'Aeschlimann Magnin, E.']
        ].each do |name, normalized|
          it "tokenizes #{name.inspect}" do
            expect(Normalizer.instance.normalize_names(name)).to eq(normalized)
          end
        end

      end

      describe '#normalize_editor' do
        it "strips in from beginning" do
          expect(n.normalize_editor(:editor => 'In D. Knuth (ed.)')).to eq({ :editor => 'Knuth, D.' })
          expect(n.normalize_editor(:editor => 'In: D. Knuth (ed.)')).to eq({ :editor => 'Knuth, D.' })
          expect(n.normalize_editor(:editor => 'in: D. Knuth ed.')).to eq({ :editor => 'Knuth, D.' })
          expect(n.normalize_editor(:editor => 'in D. Knuth (ed)')).to eq({ :editor => 'Knuth, D.' })
        end

        it "does not strip ed from name" do
          expect(n.normalize_editor(:editor => 'In Edward Wood')).to eq({ :editor => 'Wood, Edward' })
          expect(n.normalize_editor(:editor => 'ed by Edward Wood')).to eq({ :editor => 'Wood, Edward' })
          expect(n.normalize_editor(:editor => 'ed. by Edward Wood')).to eq({ :editor => 'Wood, Edward' })
          expect(n.normalize_editor(:editor => 'ed by Edward Wood')).to eq({ :editor => 'Wood, Edward' })
          expect(n.normalize_editor(:editor => 'In Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
          expect(n.normalize_editor(:editor => 'ed by Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
          expect(n.normalize_editor(:editor => 'ed. by Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
          expect(n.normalize_editor(:editor => 'ed by Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
        end

        it "strips et al" do
          expect(n.normalize_editor(:editor => 'Edward Wood et al')[:editor]).to eq('Wood, Edward')
          expect(n.normalize_editor(:editor => 'Edward Wood et al.')[:editor]).to eq('Wood, Edward')
          expect(n.normalize_editor(:editor => 'Edward Wood u.a.')[:editor]).to eq('Wood, Edward')
          expect(n.normalize_editor(:editor => 'Edward Wood u. a.')[:editor]).to eq('Wood, Edward')
          expect(n.normalize_editor(:editor => 'Edward Wood and others')[:editor]).to eq('Wood, Edward')
          expect(n.normalize_editor(:editor => 'Edward Wood & others')[:editor]).to eq('Wood, Edward')
        end
      end

      describe 'editors extraction' do
        it 'recognizes editors in the author field' do
          expect(n.normalize_author(:author => 'D. Knuth (ed.)')).to eq({ :editor => 'Knuth, D.' })
        end
      end

      describe 'URL extraction' do
        it 'recognizes full URLs' do
          expect(n.normalize_url(:url => 'Available at: https://www.example.org/x.pdf')).to eq({ :url => 'https://www.example.org/x.pdf' })
          expect(n.normalize_url(:url => 'Available at: https://www.example.org/x.pdf [Retrieved today]')).to eq({ :url => 'https://www.example.org/x.pdf' })
        end

        it 'tries to detect URLs without protocol' do
          expect(n.normalize_url(:url => 'Available at: www.example.org/x.pdf')).to eq({ :url => 'www.example.org/x.pdf' })
          expect(n.normalize_url(:url => 'Available at: example.org/x.pdf [Retrieved today]')).to eq({ :url => 'example.org/x.pdf' })
        end
      end

      describe 'date extraction' do
        it 'extracts month and year from a string like "(July 2009)"' do
          h = Normalizer.instance.normalize_date(:date => '(July 2009)')
          expect(h[:year]).to eq(2009)
          expect(h[:month]).to eq(7)
          expect(h).not_to have_key(:date)
          expect(h).not_to have_key(:day)
        end

        it 'extracts month and year from a string like "(1997 Sept.)"' do
          h = Normalizer.instance.normalize_date(:date => '(1997 Sept.)')
          expect(h[:year]).to eq(1997)
          expect(h[:month]).to eq(9)
          expect(h).not_to have_key(:date)
          expect(h).not_to have_key(:day)

          h = Normalizer.instance.normalize_date(:date => '(1997 Okt.)')
          expect(h[:year]).to eq(1997)
          expect(h[:month]).to eq(10)
          expect(h).not_to have_key(:day)
        end

        it 'extracts days if month and year are present' do
          h = n.normalize_date(:date => '(15 May 1984)')

          expect(h[:year]).to eq(1984)
          expect(h[:month]).to eq(5)
          expect(h[:day]).to eq(15)
        end
      end

    end

  end
end
