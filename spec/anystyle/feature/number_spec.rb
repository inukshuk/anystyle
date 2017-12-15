module AnyStyle
  describe "Number Feature" do
    let(:f) { Feature::Number.new }

    %w{ (1992) 1992 2011 1776 }.each do |year|
      it "observes :year in #{year.inspect}" do
        expect(f.observe(year)).to eq(:year)
      end
    end

    %w{ (1) (12) (123) }.each do |year|
      it "observes :year in #{year.inspect}" do
        expect(f.observe(year)).to eq(:numeric)
      end
    end

    ['pp', 'pp.', '23-4', '6124--19', '48 - 9', '19–27'].each do |page|
      it "observes :page in #{page.inspect}" do
        expect(f.observe(page)).to eq(:page)
      end
    end
  end
end
