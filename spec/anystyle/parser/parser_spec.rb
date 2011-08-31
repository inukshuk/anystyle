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
				subject.prepare('hello, world!').should == [['hello, ,', 'world! !']]
			end
		end

		describe "#label" do
			it 'returns an array of expanded token sequences' do
				subject.label('hello, world!').should == [[['hello,', 'O'], ['world!', 'O']]]
			end
		end

		
  end
end
