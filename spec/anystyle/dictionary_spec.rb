# coding: utf-8
module AnyStyle
  describe Dictionary do
    let(:dict) { Dictionary.create(adapter: :memory).open }

    %w{ philippines italy }.each do |place|
      it "#{place.inspect} should be a place name" do
        expect(dict[place] & Dictionary.code[:place]).to eq(Dictionary.code[:place])
      end
    end

    it "accepts unicode strings like 'çela' (name)" do
      expect(dict['çela'] & Dictionary.code[:name]).to be > 0
    end
	end
end
