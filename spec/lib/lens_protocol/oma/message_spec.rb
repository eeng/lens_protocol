module LensProtocol
  module OMA
    RSpec.describe Message do
      context 'tracing_in_polar_coordinates' do
        it 'should convert the "R" datasets to polar coordinates with the radiuses' do
          message = Message.from_hash(
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
          message = Message.from_hash(
            'R' => [
              [],
              [2476, 2478]
            ]
          )
          expect(message.tracing_in_polar_coordinates).to eq [
            [],
            [[0, 2476], [Math::PI, 2478]]
          ]
        end
      end

      context 'tracing_in_rectangular_coordinates' do
        it 'should convert the "R" datasets to rectangular coordinates' do
          message = Message.from_hash(
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
          message = Message.from_hash(
            'R' => [
              [2416, 2425],
              []
            ]
          )
          expect(message.tracing_in_rectangular_coordinates).to eq [
            [[2416, 0], [-2425, 0]],
            []
          ]
        end
      end
    end
  end
end