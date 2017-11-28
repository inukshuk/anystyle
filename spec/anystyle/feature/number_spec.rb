module Anystyle
  describe "Number Feature" do
    let(:f) { Feature::Number.new }

    %w{ (1992) 1992 2011 1776 }.each do |year|
      it "elicits :year from #{year.inspect}" do
        expect(f.elicit(year)).to eq(:year)
      end
    end

    %w{ (1) (12) (123) }.each do |year|
      it "elicits :year from #{year.inspect}" do
        expect(f.elicit(year)).to eq(:numeric)
      end
    end

    ['pp', 'pp.', '23-4', '6124--19', '48 - 9', '19–27'].each do |page|
      it "elicits :page from #{page.inspect}" do
        expect(f.elicit(page)).to eq(:page)
      end
    end
  end
end
