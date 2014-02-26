module Anystyle
  module Parser

    describe "Normalizer" do

      describe "#tokenize_names" do

        it "tokenizes 'A B'" do
          Normalizer.instance.normalize_names('A B').should == 'B, A'
        end

        it "tokenizes 'A, B'" do
          Normalizer.instance.normalize_names('A, B').should == 'A, B'
        end

        # it "tokenizes 'A, jr., B'" do
        #   Normalizer.instance.normalize_names('A, jr., B').should == 'A, jr., B'
        # end
        #
        # it "tokenizes 'A, B, jr.'" do
        #   Normalizer.instance.normalize_names('A, B, jr.').should == 'A, B, jr.'
        # end

        it "tokenizes 'A, B, C, D'" do
          Normalizer.instance.normalize_names('A, B, C, D').should == 'A, B and C, D'
        end

        it "tokenizes 'A, B, C'" do
          Normalizer.instance.normalize_names('A, B, C').should == 'A, B and C'
        end

        it "tokenizes 'Aa Bb, C.'" do
          Normalizer.instance.normalize_names('Aa Bb, C.').should == 'Aa Bb, C.'
        end

        it "tokenizes 'Aa Bb, Cc Dd, and E F G'" do
          Normalizer.instance.normalize_names('Aa Bb, C D, and E F G').should == 'Bb, Aa and D, C and G, E F'
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

      describe 'date extraction' do
        it 'should extract the month and year from a string like (July 2009)' do
          Normalizer.instance.normalize_date(:date => '(July 2009).').should == { :year => 2009, :month => 7 }
        end
      end

    end

  end
end
