# -*- encoding: utf-8 -*-

module Anystyle::Parser
  describe "Features" do

    describe "numbers" do
      let(:f) { Parser.feature[:numbers] }

      %w{ (1992) 1992 2011 1776 }.each do |year|
        it "returns :year for #{year.inspect}" do
          expect(f.match(year)).to eq(:year)
        end
      end

      %w{ (1) (12) (123) }.each do |year|
        it "returns :year for #{year.inspect}" do
          expect(f.match(year)).to eq(:numeric)
        end
      end

      ['pp', 'pp.', '23-4', '6124--19', '48 - 9', '19–27'].each do |page|
        it "returns :page for #{page.inspect}" do
          expect(f.match(page)).to eq(:page)
        end
      end

    end

  end
end
