# -*- encoding: utf-8 -*-

module Anystyle
	module Parser

		describe "Dictionary" do

			let(:dict) { Dictionary.instance }

			it { expect(Dictionary).not_to respond_to(:new) }		
			it { expect(dict).not_to be nil }

      describe '.modes' do
        it 'returns an array' do
          expect(Dictionary.modes).to be_a(Array)
        end
        
        it 'contains at least :hash' do
          expect(Dictionary.modes).to include(:hash)
        end
      end

			describe "the dictionary" do

				%w{ philippines italy }.each do |place|
					it "#{place.inspect} should be a place name" do
						expect(dict[place]).to eq(Dictionary.code[:place])
					end
				end

				it "accepts unicode strins like 'çela' (surname)" do
					expect(dict['çela'] & Dictionary.code[:surname]).to be > 0
				end

			end

		end

	end
end