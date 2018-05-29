# -*- encoding: utf-8 -*-
#
#
#      describe '#normalize_editor' do
#        it "strips in from beginning" do
#        end
#
#        it "does not strip ed from name" do
#          expect(n.normalize_editor(:editor => 'In Edward Wood')).to eq({ :editor => 'Wood, Edward' })
#          expect(n.normalize_editor(:editor => 'ed by Edward Wood')).to eq({ :editor => 'Wood, Edward' })
#          expect(n.normalize_editor(:editor => 'ed. by Edward Wood')).to eq({ :editor => 'Wood, Edward' })
#          expect(n.normalize_editor(:editor => 'ed by Edward Wood')).to eq({ :editor => 'Wood, Edward' })
#          expect(n.normalize_editor(:editor => 'In Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
#          expect(n.normalize_editor(:editor => 'ed by Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
#          expect(n.normalize_editor(:editor => 'ed. by Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
#          expect(n.normalize_editor(:editor => 'ed by Alfred Wood')).to eq({ :editor => 'Wood, Alfred' })
#        end
#
#        it "strips et al" do
#          expect(n.normalize_editor(:editor => 'Edward Wood et al')[:editor]).to eq('Wood, Edward')
#          expect(n.normalize_editor(:editor => 'Edward Wood et al.')[:editor]).to eq('Wood, Edward')
#          expect(n.normalize_editor(:editor => 'Edward Wood u.a.')[:editor]).to eq('Wood, Edward')
#          expect(n.normalize_editor(:editor => 'Edward Wood u. a.')[:editor]).to eq('Wood, Edward')
#          expect(n.normalize_editor(:editor => 'Edward Wood and others')[:editor]).to eq('Wood, Edward')
#          expect(n.normalize_editor(:editor => 'Edward Wood & others')[:editor]).to eq('Wood, Edward')
#          expect(n.normalize_editor(:editor => 'Edward Wood et coll.')[:editor]).to eq('Wood, Edward')
#        end
#      end
#
#      describe '#normalize_translator' do
#        it "strips in from beginning" do
#          expect(n.normalize_translator(:translator => 'Translated by J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'Trans by J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'Trans. by J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'Transl. J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'übersetzt von J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'übers. v. J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'Übersetzung v. J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'In der Übersetzung von J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'Trad. J Doe')).to eq({ :translator => 'Doe, J.' })
#          expect(n.normalize_translator(:translator => 'trad. J Doe')).to eq({ :translator => 'Doe, J.' })
#        end
#      end
#
#      describe 'editors extraction' do
#        it 'recognizes editors in the author field' do
#          expect(n.normalize_author(:author => 'D. Knuth (ed.)')).to eq({ :editor => 'Knuth, D.' })
#        end
#      end
#
#      describe 'URL extraction' do
#        it 'recognizes full URLs' do
#          expect(n.normalize_url(:url => 'Available at: https://www.example.org/x.pdf')).to eq({ :url => 'https://www.example.org/x.pdf' })
#          expect(n.normalize_url(:url => 'Available at: https://www.example.org/x.pdf [Retrieved today]')).to eq({ :url => 'https://www.example.org/x.pdf' })
#        end
#
#        it 'tries to detect URLs without protocol' do
#          expect(n.normalize_url(:url => 'Available at: www.example.org/x.pdf')).to eq({ :url => 'www.example.org/x.pdf' })
#          expect(n.normalize_url(:url => 'Available at: example.org/x.pdf [Retrieved today]')).to eq({ :url => 'example.org/x.pdf' })
#        end
#      end
#    end
#
#  end
#end
