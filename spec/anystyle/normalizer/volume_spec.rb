module AnyStyle
  describe "Volume Normalizer" do
    let(:n) { Normalizer::Volume.new }

    it "extracts volume and issue numbers" do
      ({
        '14(2):' => { volume: ['14'], issue: ['2'] },
        'vol. 14' => { volume: ['14'] }
        # 34:
        # 45(02):
        # 31(3/4):
        # 132(3-4):
        # 13 (6023).
        # 93(September/October 2011).
        # vol. 93, no. 2,
        # no. 10,
        # vol. 0238,
        # (vol.5.
        # Vol. 10, No. 1-3,
        # 18,
        # , vol. 379
        # 63 (serial no. 253).
        # vol. II
        # Vol. VI
        # Volume Two
        # Т. 1.
        # n° 82,
        # XIV:4
        # 105(C10)
        # B200
        # 14(Suppl.1),
        # Vol. 2 Nos. 1-4,
        # Vol. 2 Nos. 3&4,
        # [4]
        # SAC-4
        # 20</italic>
        # Vol. LXVI(6),
        # 28</italic>(1),
        # Vol. 34, No. 369-370,
        # vol. 21, no. 61 [1],
        # vol. XXXI, nº 2,
        # XXXVI/1-2
        # 47ème année, n°1,
        # Isuue 140,
        # 40 (4), art. no. 5446343,
        # 14, n° 1
        # 129, 4, Pt. 2:
        # Vol. 47, Iss. 4,
        # vol. CLXXXIII, fasc. 603,
        # 85.2 (Apr.):

      }).each do |(a, b)|
        expect(n.normalize(volume: [a])).to include(b)
      end
    end

    it "extracts page numbers"
      # 17(1)73-84.
      # 0731-5090 vol.34 no.2

    context "(item has no date)" do
      it "extracts date if possible"
      # Vol. 320, No. 7237,
      # 2008;2(3):
      # 2009;22
      # 321(9859)
      # 494-495(2014):
    end

    context "(item has date)" do
      it "does not extract date"
    end
  end
end
