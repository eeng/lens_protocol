module LensProtocol
  module OMA
    RSpec.describe Message do
      context 'values_of' do
        it 'returns the record values' do
          message = Message.from_hash('JOB' => %w[123])
          expect(message.values_of('JOB')).to eq %w[123]
        end

        it 'returns nil when the record is not present' do
          message = Message.from_hash('JOB' => %w[123])
          expect(message.values_of('JOBx')).to eq nil
          expect(message.values_of('')).to eq nil
        end
      end

      context 'tracing_in_polar_coordinates' do
        it 'should convert the "R" datasets to polar coordinates with the radiuses' do
          message = Message.from_hash(
            'TRCFMT' => [[1], [1]],
            'R' => [
              [2416, 2410, 2425, 2429], # right side
              [2476, 2478, 2481, 2483]  # left side
            ]
          )
          expect(message.tracing_in_polar_coordinates).to eq [
            [[0, 2416], [Math::PI / 2, 2410], [Math::PI, 2425], [Math::PI * 3 / 2, 2429]],
            [[0, 2476], [Math::PI / 2, 2478], [Math::PI, 2481], [Math::PI * 3 / 2, 2483]]
          ]
        end

        it 'when only one side is present' do
          message = OMA.parse <<~OMA
            TRCFMT=1;2;E;L;F
            R=2476;2478
          OMA
          expect(message.tracing_in_polar_coordinates).to eq [
            [],
            [[0, 2476], [Math::PI, 2478]]
          ]
        end

        it 'when there are no "R" records' do
          expect(Message.new.tracing_in_polar_coordinates).to eq []
        end

        it 'other tracing formats are ignored' do
          message = OMA.parse <<~OMA
            TRCFMT=6;360;E;R;F
            R=6167514141436D71
          OMA
          expect(message.tracing_in_polar_coordinates).to eq []
        end
      end

      context 'tracing_in_rectangular_coordinates' do
        it 'should convert the "R" datasets to rectangular coordinates' do
          message = Message.from_hash(
            'TRCFMT' => [[1], [1]],
            'R' => [
              [2416, 2410, 2425, 2429],
              [2476, 2478, 2481, 2483]
            ]
          )
          expect(message.tracing_in_rectangular_coordinates).to eq [
            [[2416, 0], [0, 2410], [-2425, 0], [0, -2429]],
            [[2476, 0], [0, 2478], [-2481, 0], [0, -2483]]
          ]
        end

        it 'when only one side is present' do
          message = Message.from_hash('TRCFMT' => [[1], []], 'R' => [[2416, 2425], []])
          expect(message.tracing_in_rectangular_coordinates).to eq [
            [[2416, 0], [-2425, 0]],
            []
          ]
        end
      end

      context 'merge' do
        it "add the other message's records that aren't already present in the receiver" do
          m1 = Message.from_hash('A' => 1, 'B' => 2)
          m2 = Message.from_hash('A' => 11, 'CC' => 33)
          expect(m1.merge(m2).to_hash).to eq('A' => 11, 'B' => 2, 'CC' => 33)
        end

        it 'returns a new message without changing the originals' do
          m1 = Message.from_hash('A' => 1)
          m2 = Message.from_hash('A' => 2)
          m1.merge(m2)
          expect(m1.to_hash).to eq 'A' => 1
          expect(m2.to_hash).to eq 'A' => 2
        end
      end

      context 'except' do
        it 'returns a new message excluding the specified values' do
          m1 = Message.from_hash('A' => 1, 'B' => 2)
          m2 = m1.except(%w[B])
          expect(m1.to_hash).to eq 'A' => 1, 'B' => 2
          expect(m2.to_hash).to eq 'A' => 1
        end
      end

      context 'only' do
        it 'returns a new message excluding the specified values' do
          m1 = Message.from_hash('A' => 1, 'B' => 2)
          m2 = m1.only(%w[B])
          expect(m1.to_hash).to eq 'A' => 1, 'B' => 2
          expect(m2.to_hash).to eq 'B' => 2
        end
      end

      context 'to_s' do
        it 'generates the OMA formatted string with the Windows line endings' do
          expect(Message.from_hash('A' => [1], 'B' => [2, 3]).to_s).to eq "A=1\r\nB=2;3\r\n"
        end
      end
    end
  end
end
