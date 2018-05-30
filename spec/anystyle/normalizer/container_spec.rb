module AnyStyle
  describe Normalizer::Container do
    def n(value)
      Normalizer::Container.new.normalize({
        'container-title': [value]
      })[:'container-title'][0]
    end

    it "removes leading 'In'" do
      expect(n('in 20th ACM')).to eql('20th ACM')
      expect(n('in Advances in')).to eql('Advances in')
      expect(n('in Proceedings of')).to eql('Proceedings of')
      expect(n('In Proceedings of')).to eql('Proceedings of')
      expect(n('In: Proceedings of')).to eql('Proceedings of')
      expect(n('in: Proceedings of')).to eql('Proceedings of')
      expect(n('in the Proceedings of')).to eql('Proceedings of')
      expect(n('In the Proceedings of')).to eql('Proceedings of')
      expect(n('In The Proceedings of')).to eql('The Proceedings of')
      expect(n('In IEEE')).to eql('IEEE')
    end
  end
end
