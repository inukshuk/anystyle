module Anystyle::Parser
  describe Parser do
    
    it { should_not be nil }
    
		describe "#tokenize" do
			it "returns [] when given and empty string" do
				subject.tokenize('').should == []
			end
			
		  it "takes a single line and returns an array of token sequences" do
				subject.tokenize('hello, world!').should == [%w{ hello, world! }]
			end
			
		  it "takes two lines and returns an array of token sequences" do
				subject.tokenize("hello, world!\ngoodbye!").should == [%w{ hello, world! }, %w{ goodbye! }]
			end
			
		end
		
		describe "#prepare" do
			it 'returns an array of expanded token sequences' do
				subject.prepare('hello, world!').should == [['hello, , h he hel hell , o, lo, llo, hello other none 0 no-male no-female no-family no-month no-place no-publisher none 0 internal other', 'world! ! w wo wor worl ! d! ld! rld! world other none 36 no-male no-female family no-month no-place publisher none 5 terminal other']]
			end
		end

		describe "#label" do
			it 'returns an array of expanded token sequences' do
				subject.label('hello, world!').should == [[['hello,', 'location'], ['world!', 'location']]]
			end
		end

		
  end
end
