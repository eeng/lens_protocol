module LensProtocol
  module OMA
    RSpec.describe Parser do
      context 'parse' do
        it 'expects a string and returns the parsed message' do
          message = Parser.parse <<~OMA
            REQ=FIL
            SPH=2.50;1.25
          OMA
          expect(message).to be_a(Message)
          expect(message.records.map(&:label)).to eq %w[REQ SPH]
        end

        it 'should tolerate different line separators' do
          message = Parser.parse "A=B\r\nC=D"
          expect(message.to_hash).to eq('A' => ['B'], 'C' => ['D'])
        end

        it 'some records store numeric values' do
          message = Parser.parse <<~OMA
            FTYP=1
            ETYP=2
            DBL=1.25
            NPD=30.50;-30.75
          OMA
          expect(message['FTYP'].values).to eq [1]
          expect(message['ETYP'].values).to eq [2]
          expect(message['DBL'].values).to eq [1.25]
          expect(message['NPD'].values).to eq [30.5, -30.75]
        end

        it 'should preserve empty values' do
          expect(Parser.parse('IPD=33;')['IPD'].values).to eq [33, nil]
          expect(Parser.parse('IPD=;33')['IPD'].values).to eq [nil, 33]
        end

        it 'chiral records can be accessed by side' do
          message = Parser.parse <<~OMA
            SPH=1.25;-2.00
            CYL=-1.50;3.75
          OMA
          expect(message['SPH'].right_value).to eq 1.25
          expect(message['SPH'].left_value).to eq -2.0
          expect(message['CYL'].right_value).to eq -1.5
          expect(message['CYL'].left_value).to eq 3.75
        end

        skip "some records are chiral but with each side's raw value appearing in a separate line" do
          message = Parser.parse <<~OMA
            TRCFMT=1;1000;E;R;P
            TRCFMT=1;1000;E;L;P
          OMA
          expect(message['TRCFMT'].values).to eq [
            %w[1 1000 E R P],
            %w[1 1000 E L P]
          ]
        end
      end
    end
  end
end
