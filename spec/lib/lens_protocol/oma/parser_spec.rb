module LensProtocol
  module OMA
    RSpec.describe Parser do
      context 'parse' do
        it 'expects a string a return the parsed message' do
          message = Parser.parse <<~OMA
            REQ=FIL
            SPH=2.50;1.25
          OMA
          expect(message).to be_a(Message)
          expect(message.records.map(&:label)).to eq %w[REQ SPH]
        end

        it 'should tolerate different line separators' do
          message = Parser.parse "A=B\r\nC=D"
          expect(message.to_hash).to eq('A' => 'B', 'C' => 'D')
        end
      end
    end
  end
end
