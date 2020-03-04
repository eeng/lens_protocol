module LensProtocol
  module OMA
    RSpec.describe Builder do
      context 'build' do
        it 'constructs a message from a hash' do
          message = subject.build('JOB' => 1, 'SPH' => [1, 2])

          expect(message).to be_a Message
          expect(message.value_of('JOB')).to eq 1
          expect(message.value_of('SPH')).to eq [1, 2]
        end

        it 'values can be nil' do
          expect(subject.build('JOB' => nil).value_of('JOB')).to be nil
        end

        context 'chiral records' do
          let(:types) { {'X' => Types::Chiral.new} }

          it 'if no elements are provided should asign nil to both sides' do
            expect(subject.build({'X' => []}, types: types).value_of('X')).to eq [nil, nil]
          end

          it 'if more than two values are provided the rest are discarded' do
            expect(subject.build({'X' => [1, 2, 3]}, types: types).value_of('X')).to eq [1, 2]
          end

          it 'if a single value is provided it is copied to both sides' do
            expect(subject.build({'X' => 1}, types: types).value_of('X')).to eq [1, 1]
            expect(subject.build({'X' => [1]}, types: types).value_of('X')).to eq [1, 1]
          end

          it 'when two elements are provided they remain as such' do
            expect(subject.build({'X' => [1, nil]}, types: types).value_of('X')).to eq [1, nil]
            expect(subject.build({'X' => [nil, 1]}, types: types).value_of('X')).to eq [nil, 1]
          end
        end

        context 'tracing datasets' do
          it 'when both sides are present' do
            message = subject.build(
              'TRCFMT' => [
                %w[1 360 E R F],
                %w[1 360 E L F]
              ],
              'R' => [
                [2416, 2410, 2425, 2429],
                [2476, 2478, 2481, 2483]
              ]
            )
            right_side, left_side = message.value_of('TRCFMT')

            expect(right_side.side).to eq 'R'
            expect(right_side.radius_data).to eq [2416, 2410, 2425, 2429]

            expect(left_side.side).to eq 'L'
            expect(left_side.radius_data).to eq [2476, 2478, 2481, 2483]

            expect(message.include?('R')).to be false
          end

          it 'when only the right side is present' do
            message = subject.build(
              'TRCFMT' => [%w[1 360 E R F], nil],
              'R' => [[2416, 2410, 2425, 2429], nil]
            )
            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side.side).to eq 'R'
            expect(right_side.radius_data).to eq [2416, 2410, 2425, 2429]
            expect(left_side).to be nil
          end

          it 'when only the left side is present' do
            message = subject.build(
              'TRCFMT' => [nil, %w[1 360 E L F]],
              'R' => [nil, [2416, 2410, 2425, 2429]]
            )
            right_side, left_side = message.value_of('TRCFMT')
            expect(right_side).to be nil
            expect(left_side.side).to eq 'L'
            expect(left_side.radius_data).to eq [2416, 2410, 2425, 2429]
          end

          it 'the R records must be present' do
            expect { subject.build('TRCFMT' => [%w[1 360 E L F], nil]) }.to raise_error ValidationError
          end
        end
      end
    end
  end
end
