module Anystyle
	module Parser

		describe "Normalizer" do

			describe "#tokenize_names" do

				it "tokenizes 'A B'" do
					Normalizer.instance.tokenize_names('A B').should == ['A B']
				end

				it "tokenizes 'A, B'" do
					Normalizer.instance.tokenize_names('A, B').should == ['A, B']
				end

				it "tokenizes 'A, jr., B'" do
					Normalizer.instance.tokenize_names('A, jr., B').should == ['A, jr., B']
				end

				it "tokenizes 'A, B, jr.'" do
					Normalizer.instance.tokenize_names('A, B, jr.').should == ['A, B, jr.']
				end

				it "tokenizes 'A, B, C, D'" do
					Normalizer.instance.tokenize_names('A, B, C, D').should == ['A, B', ' C, D']
				end

				it "tokenizes 'A, B, C'" do
					Normalizer.instance.tokenize_names('A, B, C').should == ['A, B', ' C']
				end

				it "tokenizes 'Aa Bb, C.'" do
					Normalizer.instance.tokenize_names('Aa Bb, C.').should == ['Aa Bb, C.']
				end
				
				it "tokenizes 'Aa Bb, Cc Dd, and E F G'" do
					Normalizer.instance.tokenize_names('Aa Bb, C D, and E F G').should == ['Aa Bb', ' C D', ' E F G']
				end
				
			end
		end

	end
end