# -*- encoding: utf-8 -*-

module Anystyle
	module Parser

		describe "Dictionary" do

			let(:dict) { Dictionary.instance }

			it { Dictionary.should_not respond_to(:new) }		
			it { dict.should_not be nil }

      describe '.modes' do
        it 'returns an array' do
          Dictionary.modes.should be_a(Array)
        end
        
        it 'contains at least :hash' do
          Dictionary.modes.should include(:hash)
        end
      end

			describe "the dictionary" do

				%w{ philippines italy }.each do |place|
					it "#{place.inspect} should be a place name" do
						dict[place].should == Dictionary.code[:place]
					end
				end

				it "accepts unicode strins like 'çela' (surname)" do
					(dict['çela'] & Dictionary.code[:surname]).should > 0
				end

			end

		end

	end
end