module Anystyle
	module Parser

		describe "Dictionary" do
      let(:dict) { Dictionary.create.open }

			describe "the dictionary" do
				%w{ philippines italy }.each do |place|
					it "#{place.inspect} should be a place name" do
						expect(dict[place]).to eq(Dictionary.code[:place])
					end
				end

				it "accepts unicode strings like 'çela' (surname)" do
					expect(dict['çela'] & Dictionary.code[:surname]).to be > 0
				end
			end
		end

	end
end
