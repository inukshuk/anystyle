module Anystyle::Parser
  describe Parser do
    
    it { should_not be nil }
    
		describe "#tokenize" do
			it "returns [] when given and empty string" do
				Parser.new.tokenize('').should == []
			end
			
		  it "takes a single line and returns an array of token sequences" do
				Parser.new.tokenize('hello, world!').should == [%w{ hello, world! }]
			end
			
		  it "takes two lines and returns an array of token sequences" do
				Parser.new.tokenize("hello, world!\ngoodbye!").should == [%w{ hello, world! }, %w{ goodbye! }]
			end
			
		end
		
		describe "#prepare" do
		  let(:parser) do
				p = Parser.new
				p.features = double(:features)
				p.features.stub(:expand) { |t| [t,'X'].join(' ') }
				p
			end
			
			it 'returns an array of expanded token sequences' do
				parser.prepare('hello, world!').should == [['hello, X', 'world! X']]
			end
		end

		describe "#label" do
		  let(:parser) do
				p = Parser.new
				p.features = double(:features)
				p.features.stub(:expand) { |t| [t,'X'].join(' ') }
				p
			end
			
			it 'returns an array of expanded token sequences' do
				parser.label('hello, world!').should == [[['hello,', 'O'], ['world!', 'O']]]
			end
		end

		
  end
end
