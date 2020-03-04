module LensProtocol
  module OMA
    RSpec.describe Parser do
      context 'parse' do
        it 'expects a string and returns the parsed message' do
          message = subject.parse('REQ=FIL')
          expect(message).to be_a(Message)
        end

        it 'single value text records' do
          message = subject.parse('X=A', types: {'X' => Types::Single.new})
          expect(message.value_of('X')).to eq 'A'
          message = subject.parse('X=A;B;C', types: {'X' => Types::Single.new})
          expect(message.value_of('X')).to eq 'A;B;C'
          message = subject.parse('JOB=123')
          expect(message.value_of('JOB')).to eq '123'
        end

        it 'single value numeric records' do
          message = subject.parse <<~OMA
            FTYP=1
            ETYP=2
            DBL=1.25
          OMA
          expect(message.value_of('FTYP')).to eq 1
          expect(message.value_of('ETYP')).to eq 2
          expect(message.value_of('DBL')).to eq 1.25
        end

        it 'should be able to parse as integer a decimal value' do
          message = subject.parse('X=12.00', types: {'X' => Types::Single.new(value_type: :integer)})
          expect(message.value_of('X')).to eq 12
        end

        it 'array of text values records' do
          message = subject.parse('X=A;B;C', types: {'X' => Types::Array.new})
          expect(message.value_of('X')).to eq %w[A B C]
        end

        it 'array of numeric values' do
          message = subject.parse('R=10;11;12', types: {'R' => Types::Array.new(value_type: :integer)})
          expect(message.value_of('R')).to eq [10, 11, 12]
        end

        it 'chiral text records' do
          message = subject.parse('LNAM=A;B')
          expect(message.value_of('LNAM')).to eq %w[A B]

          message = subject.parse 'LNAM=X'
          expect(message.value_of('LNAM')).to eq %w[X X]
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

          message = subject.parse 'SPH='
          expect(message.value_of('SPH')).to eq [nil, nil]
        end

        it 'matrix of values records' do
          message = subject.parse <<~OMA
            XSTATUS=R;2300;Msg1
            XSTATUS=R;2301;Msg2
          OMA

          expect(message.value_of('XSTATUS')).to eq [
            %w[R 2300 Msg1],
            %w[R 2301 Msg2]
          ]
        end

        context 'parsing of tracing datasets' do
          it 'when both sides are present, right first and then left' do
            message = subject.parse <<~OMA
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
              TRCFMT=1;10;E;L;P
              R=2476;2478;2481;2483;2486
              R=2503;2506;2510;2513;2516
            OMA

            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side.radius_data).to eq [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478]
            expect(left_side.radius_data).to eq [2476, 2478, 2481, 2483, 2486, 2503, 2506, 2510, 2513, 2516]
          end

          it 'when both sides are present, left first and then right, and there is another record in between' do
            message = subject.parse <<~OMA
              TRCFMT=1;10;E;L;P
              R=2476;2478;2481;2483;2486
              R=2503;2506;2510;2513;2516
              _BLANK=...
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
            OMA

            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side.radius_data).to eq [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478]
            expect(left_side.radius_data).to eq [2476, 2478, 2481, 2483, 2486, 2503, 2506, 2510, 2513, 2516]
          end

          it 'when only one side is present' do
            message = subject.parse <<~OMA
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
            OMA

            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side.radius_data).to eq [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478]
            expect(left_side).to eq nil

            message = subject.parse <<~OMA
              TRCFMT=1;10;E;L;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
            OMA

            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side).to eq nil
            expect(left_side.radius_data).to eq [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478]
          end

          it 'should store the raw data when the tracing format is unknown' do
            message = subject.parse <<~OMA
              TRCFMT=6;360;E;R;F
              R=49675141414A4E436A654671314C2F355A564A423776324A4439...
              TRCFMT=6;360;E;L;F
              R=4B675141414838754E347A4F6352316269616D67344D372F6C79...
            OMA

            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side.radius_data).to eq %w[49675141414A4E436A654671314C2F355A564A423776324A4439...]
            expect(left_side.radius_data).to eq %w[4B675141414838754E347A4F6352316269616D67344D372F6C79...]
          end

          it 'should not store the R value directly on the message' do
            message = subject.parse <<~OMA
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
            OMA

            expect(message.include?('R')).to be false
          end

          it 'R records without its corresponding TRCFMT are ignored' do
            expect(subject.parse('R=2416;2410;2425;2429;2433').include?('R')).to eq false
          end

          it 'should not mix R records of other datasets' do
            message = subject.parse <<~OMA
              TRCFMT=1;10;E;R;P
              R=2416;2410;2425;2429;2433
              R=2459;2464;2469;2473;2478
              STHKFMT=1;4;E;R
              R=2574;2659;2745;2838
            OMA

            right_side, = message.value_of('TRCFMT')
            expect(right_side.radius_data).to eq [2416, 2410, 2425, 2429, 2433, 2459, 2464, 2469, 2473, 2478]
          end
        end

        it 'should tolerate different line separators' do
          message = subject.parse "A=B\r\nC=D"
          expect(message.to_hash).to eq('A' => 'B', 'C' => 'D')
        end

        it 'should preserve empty values' do
          expect(subject.parse('IPD=33;').value_of('IPD')).to eq [33, nil]
          expect(subject.parse('IPD=;33').value_of('IPD')).to eq [nil, 33]
          expect(subject.parse('JOB=').value_of('JOB')).to eq ''
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

          it 'all lines should have the label separator' do
            expect { subject.parse('A') }.to raise_error ParsingError
          end
        end
      end
    end
  end
end
