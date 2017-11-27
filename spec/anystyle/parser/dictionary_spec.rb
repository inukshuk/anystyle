module Anystyle
	module Parser

		describe "Dictionary" do

			describe "Hash Adapter" do
        let(:dict) { Dictionary.create.open }

				%w{ philippines italy }.each do |place|
					it "#{place.inspect} should be a place name" do
						expect(dict[place]).to eq(Dictionary.code[:place])
					end
				end

				it "accepts unicode strings like 'çela' (surname)" do
					expect(dict['çela'] & Dictionary.code[:surname]).to be > 0
				end
			end

      describe "Redis Adapter" do
        let(:dict) { Dictionary.create(adapter: :redis) }

        it "is a Dictionary" do
          expect(dict).to be_a(Dictionary)
          expect(dict).to be_instance_of(Dictionary::Redis)
        end

      end
		end

	end
end
