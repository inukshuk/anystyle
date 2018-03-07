module AnyStyle
  describe "Number Feature" do
    let(:f) { Feature::Keyword.new }

    it "observes :none when no keyword" do
      expect(f.observe(nil, '')).to eq(:none)
    end

    %w{ ed editor eds Ed Eds editors }.each do |alpha|
      it "observes :editor in #{alpha.inspect}" do
        expect(f.observe(nil, alpha)).to eq(:editor)
      end
    end

    it "observes :and for matching token" do
      expect(f.observe('&', '')).to eq(:and)
      expect(f.observe(nil, 'and')).to eq(:and)
      expect(f.observe(nil, 'und')).to eq(:and)
    end

    %w{ vol volume volumes n no nr number issue }.each do |alpha|
      it "observes :volume in #{alpha.inspect}" do
        expect(f.observe(nil, alpha)).to eq(:volume)
      end
    end

    %w{ September may jan spring winter Sommer }.each do |alpha|
      it "observes :date in #{alpha.inspect}" do
        expect(f.observe(nil, alpha)).to eq(:date)
      end
    end

    %w{ accessed retrieved }.each do |alpha|
      it "observes :accessed in #{alpha.inspect}" do
        expect(f.observe(nil, alpha)).to eq(:accessed)
      end
    end
  end
end
