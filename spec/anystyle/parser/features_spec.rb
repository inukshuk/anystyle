# -*- encoding: utf-8 -*-

module Anystyle::Parser
	describe "Features" do
	  
		describe "numbers" do
			let(:f) { Parser.feature[:numbers] }
			
			%w{ (1992) 1992 2011 1776 }.each do |year|
				it "returns :year for #{year.inspect}" do
					f.match(year).should == :year
				end
			end
			
			%w{ (1) (12) (123) }.each do |year|
				it "returns :year for #{year.inspect}" do
					f.match(year).should == :numeric
				end
			end
			
		end
		
		describe ".dict" do
		
			%w{ philippines italy }.each do |place|
				it "#{place.inspect} should be a place name" do
					Feature.dict[place].to_i.should == Feature.dict_code[:place]
				end
			end
			
			it "çela is a surname" do
				(Feature.dict['çela'].to_i & Feature.dict_code[:surname]).should > 0
			end
			
		end
				
	end
end