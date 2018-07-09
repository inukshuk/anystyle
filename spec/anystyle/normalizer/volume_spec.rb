module AnyStyle
  describe "Volume Normalizer" do
    let(:n) { Normalizer::Volume.new }

    it "extracts volume and issue numbers" do
      ({
        '14(2):' => { volume: ['14'], issue: ['2'] },
        'vol. 14' => { volume: ['14'] },
        '34:' => { volume: ['34'] },
        '45(02):' => { volume: ['45'], issue: ['02'] },
        '31(3/4):' => { volume: ['31'], issue: ['3/4'] },
        '132(3-4):' => { volume: ['132'], issue: ['3-4'] },
        '13 (6023).' => { volume: ['13'], issue: ['6023'] },
        '93(September/October 2011).' => { volume: ['93'], issue: ['September/October 2011'] },
        'vol. 93, no. 2,' => { volume: ['93'], issue: ['2'] },
        'no. 10,' => { issue: ['10'] },
        'vol. 0238,' => { volume: ['0238'] },
        '(vol.5.' => { volume: ['5'] },
        'Vol. 10, No. 1-3,' => { volume: ['10'], issue: ['1-3'] },
        '18,' => { volume: ['18'] },
        ', vol. 379' => { volume: ['379'] },
        '63 (serial no. 253).' => { volume: ['63'], issue: ['serial no. 253'] },
        'vol. II' => { volume: ['II'] },
        'Vol. VI' => { volume: ['VI'] },
        'Volume Two' => { volume: ['Two'] },
        'Т. 1.' => { volume: ['Т. 1'] },
        'n° 82,' => { issue: ['82'] },
        # XIV:4
        '105(C10)' => { volume: ['105'], issue: ['C10'] },
        'B200' => { volume: ['B200'] },
        '14(Suppl.1),' => { volume: ['14'], issue: ['Suppl.1'] },
        'Vol. 2 Nos. 1-4,' => { volume: ['2'], issue: ['1-4'] },
        'Vol. 2 Nos. 3&4,' => { volume: ['2'], issue: ['3&4'] },
        '[4]' => { volume: ['4'] },
        'SAC-4' => { volume: ['SAC-4'] },
        '14, n° 1' => { volume: ['14'], issue: ['1'] },
        'Vol. 47, Iss. 4,' => { volume: ['47'], issue: ['4'] },
        'Vol. 34, No. 369-370,' => { volume: ['34'], issue: ['369-370'] },
        'vol. 21, no. 61 [1],' => { volume: ['21'], issue: ['61 [1]'] },
        '85.2 (Apr.):' => { volume: ['85'], issue: ['2'] },
        '20</italic>' => { volume: ['20'] },
        '28</italic>(1),' => { volume: ['28'], issue: ['1'] },
        'Vol. LXVI(6),' => { volume: ['LXVI'], issue: ['6'] },
        'vol. XXXI, nº 2,' => { volume: ['XXXI'], issue: ['2'] },
        'XXXVI/1-2,' => { volume: ['XXXVI'], issue: ['1-2'] },
        'vol. CLXXXIII, fasc. 603,' => { volume: ['CLXXXIII'], issue: ['603'] }
        # 47ème année, n°1,
        # Isuue 140,
        # 40 (4), art. no. 5446343,
        # 129, 4, Pt. 2:

      }).each do |(a, b)|
        expect(n.normalize(volume: [a])).to include(b)
      end
    end

    it "extracts number of volumes" do
      expect(n.normalize(volume: ['8 vols.'])).to include(volume: ['8'])
    end

    it "extracts page numbers" do
      ({
        '17(1)73-84.' => { volume: ['17'], issue: ['1'], pages: ['73-84'] },
        '51:197-204' => { volume: ['51'], pages: ['197-204'] }
      }).each do |(a, b)|
        expect(n.normalize(volume: [a])).to include(b)
      end
    end

    context "(item has no date)" do
      it "extracts date if possible" do
        ({
          'Vol. 320, No. 7237,' => { volume: ['320'], issue: ['7237'] },
          '2008;2(3):' => { volume: ['2'], issue: ['3'], date: ['2008'] },
          '2009;22' => { volume: ['22'], date: ['2009'] },
          '321(9859)' => { volume: ['321'], issue: ['9859'] },
          '494-495(2014):' => { volume: ['494-495'], date: ['2014'] }
        }).each do |(a, b)|
          expect(n.normalize(volume: [a])).to include(b)
        end
      end
    end

    context "(item has date)" do
      it "does not extract date"
    end
  end
end
