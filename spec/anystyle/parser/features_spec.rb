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
						
	end
end