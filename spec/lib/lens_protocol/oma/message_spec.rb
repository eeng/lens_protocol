module LensProtocol
  module OMA
    RSpec.describe Message do
      context 'value_of' do
        it 'returns the record value' do
          message = Message.from_hash('JOB' => 'X')
          expect(message.value_of('JOB')).to eq 'X'
        end

        it 'returns the default value when the record is not present' do
          message = Message.from_hash('JOB' => '123')
          expect(message.value_of('JOBx')).to eq nil
          expect(message.value_of('JOBx', 'the default')).to eq 'the default'
          expect(message.value_of('')).to eq nil
        end
      end

      context 'tracing_in_polar_coordinates' do
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
          expect(message.tracing_in_polar_coordinates).to eq [[], []]
        end
      end

      context 'tracing_in_rectangular_coordinates' do
        it 'when only one side is present' do
          message = Message.from_hash('TRCFMT' => [%w[1 2 E R F], nil], 'R' => [[2416, 2425], nil])
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

      context 'remove_empty_records' do
        it 'removes records with no values' do
          m = Message.from_hash('VIEWP' => [], 'B' => 1, 'C' => '')
          expect(m.remove_empty_records.to_hash).to eq 'B' => 1
        end
      end

      context 'empty?' do
        it 'returns true if it has no records' do
          expect(Message.new).to be_empty
          expect(Message.from_hash('A' => 1)).to_not be_empty
        end
      end

      context 'to_s' do
        it 'uses the formatter to generate the OMA string' do
          expect(Message.from_hash('A' => 1).to_s).to eq "A=1\r\n"
        end
      end
    end
  end
end
