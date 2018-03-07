module AnyStyle
  describe "Number Feature" do
    let(:f) { Feature::Number.new }

    %w{ (1992) 1992. 2011, 1776; 1970/71 (2000 2001) (2014). }.each do |num|
      it "observes :year in #{num.inspect}" do
        expect(f.observe(num)).to eq(:year)
      end
    end

    %w{ (1) (12) (123) }.each do |num|
      it "observes :numeric in #{num.inspect}" do
        expect(f.observe(num)).to eq(:numeric)
      end
    end

    %w{ 1st 2nd 3rd 4th 11th 1te 47ème 1st. 2nd; 3rd) }.each do |num|
      it "observes :numeric in #{num.inspect}" do
        expect(f.observe(num)).to eq(:ordinal)
      end
    end

    %w{ 1(1) 23(12) 4(123) 2001;32(3). }.each do |num|
      it "observes :volume in #{num.inspect}" do
        expect(f.observe(num)).to eq(:volume)
      end
    end

    ['23-4', '6124--19', '19–27'].each do |page|
      it "observes :range in #{page.inspect}" do
        expect(f.observe(page)).to eq(:range)
      end
    end

    %w{ X LX IV IX III II I MX vii iv }.each do |num|
      it "observes :roman in #{num.inspect}" do
        expect(f.observe(num)).to eq(:roman)
      end
    end
  end
end
