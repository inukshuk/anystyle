module Anystyle
  module Parser

    describe "Normalizer" do
      let(:n) { Normalizer.instance }

      describe "#tokenize_names" do

        it "tokenizes 'A B'" do
          Normalizer.instance.normalize_names('A B').should == 'B, A.'
        end

        it "tokenizes 'A, B'" do
          Normalizer.instance.normalize_names('A, B').should == 'A, B.'
        end

        # it "tokenizes 'A, jr., B'" do
        #   Normalizer.instance.normalize_names('A, jr., B').should == 'A, jr., B'
        # end
        #
        # it "tokenizes 'A, B, jr.'" do
        #   Normalizer.instance.normalize_names('A, B, jr.').should == 'A, B, jr.'
        # end

        it "tokenizes 'A, B, C, D'" do
          Normalizer.instance.normalize_names('A, B, C, D').should == 'A, B. and C, D.'
        end

        it "tokenizes 'A, B, C'" do
          Normalizer.instance.normalize_names('A, B, C').should == 'A, B. and C'
        end

        it "tokenizes 'Aa Bb, C.'" do
          Normalizer.instance.normalize_names('Aa Bb, C.').should == 'Aa Bb, C.'
        end

        it "tokenizes 'Aa Bb, Cc Dd, and E F G'" do
          Normalizer.instance.normalize_names('Aa Bb, C D, and E F G').should == 'Bb, Aa and D, C. and G, E. F.'
        end

        [
          ['Poe, Edgar A.', 'Poe, Edgar A.'],
          ['Edgar A. Poe', 'Poe, Edgar A.'],
          ['Edgar A. Poe, Herman Melville', 'Poe, Edgar A. and Melville, Herman'],
          ['Poe, Edgar A., Melville, Herman', 'Poe, Edgar A. and Melville, Herman'],
          ['Aeschlimann Magnin, E.', 'Aeschlimann Magnin, E.']
        ].each do |name, normalized|
          it "tokenizes #{name.inspect}" do
            Normalizer.instance.normalize_names(name).should == normalized
          end
        end

      end

      describe 'editors extraction' do
        it 'recognizes editors in the author field' do
          n.normalize_author(:author => 'D. Knuth (ed.)').should == { :editor => 'Knuth, D.' }
        end
      end

      describe 'URL extraction' do
        it 'recognizes full URLs' do
          n.normalize_url(:url => 'Available at: https://www.example.org/x.pdf').should == { :url => 'https://www.example.org/x.pdf' }
          n.normalize_url(:url => 'Available at: https://www.example.org/x.pdf [Retrieved today]').should == { :url => 'https://www.example.org/x.pdf' }
        end

        it 'tries to detect URLs without protocol' do
          n.normalize_url(:url => 'Available at: www.example.org/x.pdf').should == { :url => 'www.example.org/x.pdf' }
          n.normalize_url(:url => 'Available at: example.org/x.pdf [Retrieved today]').should == { :url => 'example.org/x.pdf' }
        end
      end

      describe 'date extraction' do
        it 'extracts month and year from a string like "(July 2009)"' do
          h = Normalizer.instance.normalize_date(:date => '(July 2009)')
          h[:year].should == 2009
          h[:month].should == 7
          h.should_not have_key(:date)
        end

        it 'extracts month and year from a string like "(1997 Sept.)"' do
          h = Normalizer.instance.normalize_date(:date => '(1997 Sept.)')
          h[:year].should == 1997
          h[:month].should == 9
          h.should_not have_key(:date)

          h = Normalizer.instance.normalize_date(:date => '(1997 Okt.)')
          h[:year].should == 1997
          h[:month].should == 10
        end

        it 'extracts days if month and year are present' do
          h = n.normalize_date(:date => '(15 May 1984)')

          h[:year].should == 1984
          h[:month].should == 5
          h[:day].should == 15
        end
      end

    end

  end
end
