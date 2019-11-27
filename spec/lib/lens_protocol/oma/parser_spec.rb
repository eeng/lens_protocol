module LensProtocol
  module OMA
    RSpec.describe Parser do
      context 'parse' do
        it 'expects a string and returns the parsed message' do
          message = subject.parse('REQ=FIL')
          expect(message).to be_a(Message)
        end

        it 'single_value text records' do
          message = subject.parse('X=A', types: {'X' => Type::Text.new(mode: :single_value)})
          expect(message.value_of('X')).to eq 'A'
          message = subject.parse('X=A;B;C', types: {'X' => Type::Text.new(mode: :single_value)})
          expect(message.value_of('X')).to eq 'A;B;C'
          message = subject.parse('JOB=123')
          expect(message.value_of('JOB')).to eq '123'
        end

        it 'single_value numeric records' do
          message = subject.parse <<~OMA
            FTYP=1
            ETYP=2
            DBL=1.25
          OMA
          expect(message.value_of('FTYP')).to eq 1
          expect(message.value_of('ETYP')).to eq 2
          expect(message.value_of('DBL')).to eq 1.25
        end

        it 'array_of_values text records' do
          message = subject.parse('X=A;B;C', types: {'X' => Type::Text.new(mode: :array_of_values)})
          expect(message.value_of('X')).to eq %w[A B C]
        end

        it 'array_of_values numeric record in múltiple lines' do
          oma = <<~OMA
            R=10;11;12
            R=13;14;15
          OMA
          message = subject.parse(oma, types: {'R' => Type::Integer.new(mode: :array_of_values)})
          expect(message.value_of('R')).to eq [10, 11, 12, 13, 14, 15]
        end

        it 'chiral text records' do
          message = subject.parse('LNAM=A;B')
          expect(message.value_of('LNAM')).to eq %w[A B]

          message = subject.parse 'FWD=X'
          expect(message.value_of('FWD')).to eq %w[X X]
        end

        it 'chiral numeric records' do
          message = subject.parse <<~OMA
            SPH=-1.25;0.5
            NPD=30.50;-30.75
          OMA
          expect(message.value_of('SPH')).to eq [-1.25, 0.5]
          expect(message.value_of('NPD')).to eq [30.5, -30.75]

          message = subject.parse 'SPH=1'
          expect(message.value_of('SPH')).to eq [1, 1]

          message = subject.parse 'SPH=1;2;3'
          expect(message.value_of('SPH')).to eq [1, 2]
        end

        it 'matrix_of_values records' do
          message = subject.parse <<~OMA
            XSTATUS=R;2300;Error1
            XSTATUS=R;2301;Error2
          OMA

          expect(message.value_of('XSTATUS')).to eq [
            %w[R 2300 Error1],
            %w[R 2301 Error2]
          ]
        end

        context 'parsing of tracing datasets' do
          it 'when both sides are present' do
            message = subject.parse <<~OMA
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
            message = subject.parse <<~OMA
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

        it 'should tolerate different line separators' do
          message = subject.parse "A=B\r\nC=D"
          expect(message.to_hash).to eq('A' => 'B', 'C' => 'D')
        end

        it 'should preserve empty values' do
          expect(subject.parse('IPD=33;').value_of('IPD')).to eq [33, nil]
          expect(subject.parse('IPD=;33').value_of('IPD')).to eq [nil, 33]
          expect(subject.parse('JOB=').value_of('JOB')).to eq nil
        end

        it 'unknown values are converted to nil' do
          expect(subject.parse('JOB=?').value_of('JOB')).to eq nil
          expect(subject.parse('OPTFRNT=?').value_of('OPTFRNT')).to eq [nil, nil]
          expect(subject.parse('OPTFRNT=?;2.00').value_of('OPTFRNT')).to eq [nil, 2]
        end

        context 'errors' do
          it 'nil and empty messages' do
            expect(subject.parse(nil).to_hash).to be_empty
            expect(subject.parse('').to_hash).to be_empty
          end

          it '"R" records should be preceded by a corresponding TRCFMT' do
            expect { subject.parse 'R=2416;2410;2425;2429;2433' }.to raise_error ParsingError
          end
        end
      end
    end
  end
end
