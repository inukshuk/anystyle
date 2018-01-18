module AnyStyle
  describe Dictionary do
    let(:dict) { Dictionary.create(adapter: :memory).open }

    %w{ philippines italy }.each do |place|
      it "#{place.inspect} should be a place name" do
        expect(dict[place] & Dictionary.code[:place]).to be > 0
      end
    end

    it "accepts unicode strings like 'cela' (name)" do
      expect(dict['cela'] & Dictionary.code[:name]).to be > 0
    end
	end
end
