module AnyStyle
  describe Normalizer::Date do
    let(:nd) { Normalizer::Date.new }
    let(:np) { Normalizer::Punctuation.new }

    def normalize(x)
      nd.normalize(np.normalize(x))
    end

    it "extracts year" do
      ({
        '1935.' => { date: ['1935'] },
        '(2001):' => { date: ['2001'] },
        '1976,' => { date: ['1976'] },
        '1998),' => { date: ['1998'] },
        '(2009),' => { date: ['2009'] },
        '1878' => { date: ['1878'] },
        '(2016).' => { date: ['2016'] },
        '(1998b).' => { date: ['1998'] },
        '2007.' => { date: ['2007'] },
        'date inconnue :' => { date: ['XXXX'] },
        'n.d.,' => { date: ['XXXX'] }
      }).each do |(a, b)|
        expect(normalize(date: [a.dup])).to include(b)
      end
    end

    it "extracts month" do
      ({
        '[Jan 1993],' => { date: ['1993-01'] },
        '(September 1985).' => { date: ['1985-09'] },
        'April 2012.' => { date: ['2012-04'] },
        '(2004, May).' => { date: ['2004-05'] },
        #'May(26).' => { date: [''] },
        #'Septem- ber(17).' => { date: [''] },
        '(March, 1968).' => { date: ['1968-03'] },
        '(1994, March).' => { date: ['1994-03'] },
        'décembre 1931,' => { date: ['1931-12'] },
      }).each do |(a, b)|
        expect(normalize(date: [a.dup])).to include(b)
      end
    end

    it "extracts day" do
      ({
        '15 March 1985,' => { date: ['1985-03-15'] },
        '(1998, September 5).' => { date: ['1998-09-05'] },
        'Jan. 23 1973,' => { date: ['1973-01-23'] },
        'November 2, 1997,' => { date: ['1997-11-02'] },
        '(2010, January 28).' => { date: ['2010-01-28'] },
        'March 4, 2015.' => { date: ['2015-03-04'] },
        '15 novembre 1925,' => { date: ['1925-11-15'] },
        '4 January.' => { date: ['4 January'] },
        '(April 17, 1969),' => { date: ['1969-04-17'] }
      }).each do |(a, b)|
        expect(normalize(date: [a.dup])).to include(b)
      end
    end

    it "extracts intervals" do
      ({
        '(July / August 1992),' => { date: ['July / August 1992'] },
        'March - December 1994.' => { date: ['March - December 1994'] },
        '(1999/2000):' => { date: ['1999/2000'] },
        '(2006, 25-26 March).' => { date: ['2006, 25-26 March'] },
        '11 March-27 November,' => { date: ['11 March-27 November'] },
        #'(January–February 2004):' => { date: ['January–February 2004'] },
        #'(July-August, 1964).' => { date: ['July-August, 1964'] },
        'July 7-10.' => { date: ['July 7-10'] }
      }).each do |(a, b)|
        expect(normalize(date: [a.dup])).to include(b)
      end
    end

    it "extracts uncertainty" do
      expect(normalize(date: [
        '(c.2017).', 'ca. 2018);', '1994 (?)', '1984??', 'v. 2017', 'vers 2019'
      ])).to include({ date: [
        '2017~', '2018~', '1994?', '1984?', '2017~', '2019~'
      ]})
    end

    it "combines partial dates" do
      pending
      expect(normalize(date: [
        '(2017).', 'July);'
      ])).to include({ date: ['2017-07'] })
    end

    it "parses ad/bc dates"

    it "extracts original date"
    # (1984 [1970]),

  end
end
