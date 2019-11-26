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
          expect(message.values_of('FTYP')).to eq [1]
          expect(message.values_of('ETYP')).to eq [2]
          expect(message.values_of('DBL')).to eq [1.25]
          expect(message.values_of('NPD')).to eq [30.5, -30.75]
        end

        it 'should preserve empty values' do
          expect(Parser.parse('IPD=33;').values_of('IPD')).to eq [33, nil]
          expect(Parser.parse('IPD=;33').values_of('IPD')).to eq [nil, 33]
          expect(Parser.parse('JOB=').values_of('JOB')).to eq []
        end

        it 'unknown values are converted to nil' do
          expect(Parser.parse('OPTFRNT=?').values_of('OPTFRNT')).to eq [nil]
          expect(Parser.parse('OPTFRNT=?;2.00').values_of('OPTFRNT')).to eq [nil, 2]
        end

        context 'parsing of tracing datasets' do
          it 'when both sides are present' do
            message = Parser.parse <<~OMA
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
              TRCFMT=1;10;E;L;P
              R=2476;2478;2481;2483;2486
              R=2503;2506;2510;2513;2516
            OMA

            expect(message.to_hash).to eq(
              'TRCFMT' => [
                %w[1 10 E R P],
                %w[1 10 E L P]
              ],
              'R' => [
                [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478],
                [2476, 2478, 2481, 2483, 2486, 2503, 2506, 2510, 2513, 2516]
              ]
            )
          end

          it 'when only one side is present' do
            message = Parser.parse <<~OMA
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
            OMA

            expect(message.to_hash).to eq(
              'TRCFMT' => [
                %w[1 10 E R P],
                %w[]
              ],
              'R' => [
                [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478],
                []
              ]
            )
          end
        end

        context 'errors' do
          it '"R" records should be preceded by a corresponding TRCFMT' do
            expect { Parser.parse 'R=2416;2410;2425;2429;2433' }.to raise_error ParsingError
          end
        end

        context 'options' do
          it 'should be posible to override record types' do
            oma = <<~OMA
              _EXP=A1;A2
              _EXP=B1;B2
            OMA

            message = Parser.parse(oma, types: {'_EXP' => Type::MultiLineString.new})
            expect(message.values_of('_EXP')).to eq [%w[A1 A2], %w[B1 B2]]

            message = Parser.parse(oma)
            expect(message.values_of('_EXP')).to eq %w[B1 B2]
          end
        end
      end
    end
  end
end
