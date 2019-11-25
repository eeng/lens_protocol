module LensProtocol
  module OMA
    RSpec.describe Parser do
      context 'parse' do
        it 'expects a string and returns the parsed message' do
          message = Parser.parse <<~OMA
            REQ=FIL
            JOB=123
          OMA
          expect(message).to be_a(Message)
          expect(message.to_hash).to eq 'REQ' => ['FIL'], 'JOB' => ['123']
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

        skip 'parsing of tracing datasets' do
          message = Parser.parse <<~OMA
            TRCFMT=1;10;E;R;P
            R=2416;2410;2425;2429;2433
            R=2459;2464;2469;2473;2478
            TRCFMT=1;20;E;L;P
            R=2476;2478;2481;2483;2486
            R=2503;2506;2510;2513;2516
          OMA

          expect(message.to_hash).to eq(
            'TRCFMT' => [
              %w[1 10 E R P],
              %w[1 10 E L P]
            ],
            'R' => [
              [2416, 2420, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478],
              [2476, 2478, 2481, 2483, 2486, 2503, 2506, 2510, 2513, 2516]
            ]
          )
        end
      end
    end
  end
end
