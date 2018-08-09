module AnyStyle
  describe Refs do
    let(:refs) { Refs.new }

    describe 'join?' do
      it 'decides whether or not to join two reference strings' do
        fixture('ref-join.yml').each do |f|
          unless f['pending']
            expect(
              refs.join?(f['a'], f['b'], f['indent'], f['delta'])
            ).to eq(f['join']),
            "Expected #{f['a'].inspect} and #{f['b'].inspect} #{f['join'] ? '' : 'not '}to join"
          end
        end
      end
    end
  end
end
