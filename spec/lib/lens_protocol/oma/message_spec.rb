module LensProtocol
  module OMA
    RSpec.describe Message do
      context 'tracing_in_polar_coordinates' do
        it 'should convert the "R" datasets to polar coordinates with the radiuses in mm' do
          message = Message.from_hash(
            'R' => [
              [2416, 2410, 2425, 2429], # right side
              [2476, 2478, 2481, 2483]  # left side
            ]
          )
          expect(message.tracing_in_polar_coordinates).to eq [
            [[0, 24.16], [Math::PI / 2, 24.10], [Math::PI, 24.25], [Math::PI * 3 / 2, 24.29]],
            [[0, 24.76], [Math::PI / 2, 24.78], [Math::PI, 24.81], [Math::PI * 3 / 2, 24.83]]
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
            [[0, 24.76], [Math::PI, 24.78]]
          ]
        end
      end

      context 'tracing_in_rectangular_coordinates' do
        it 'should convert the "R" datasets to rectangular coordinates in mm' do
          message = Message.from_hash(
            'R' => [
              [2416, 2410, 2425, 2429],
              [2476, 2478, 2481, 2483]
            ]
          )
          expect(message.tracing_in_rectangular_coordinates).to eq [
            [[24.16, 0.0], [0.0, 24.1], [-24.25, 0.0], [0.0, -24.29]],
            [[24.76, 0.0], [0.0, 24.78], [-24.81, 0.0], [0.0, -24.83]]
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
            [[24.16, 0.0], [-24.25, 0.0]],
            []
          ]
        end
      end
    end
  end
end
