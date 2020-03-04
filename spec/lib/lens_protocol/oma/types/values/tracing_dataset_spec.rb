module LensProtocol
  module OMA
    module Types
      module Values
        RSpec.describe TracingDataset do
          context 'in_polar_coordinates' do
            it 'should convert the "R" datasets to polar coordinates with the radiuses' do
              expect(tracing_in_polar([2416, 2410, 2425, 2429]))
                .to eq [[0, 2416], [Math::PI / 2, 2410], [Math::PI, 2425], [Math::PI * 3 / 2, 2429]]

              expect(tracing_in_polar([2476, 2478, 2481, 2483]))
                .to eq [[0, 2476], [Math::PI / 2, 2478], [Math::PI, 2481], [Math::PI * 3 / 2, 2483]]
            end

            def tracing_in_polar radius_data
              TracingDataset.new(radius_data: radius_data, trcfmt_values: ['1']).in_polar_coordinates
            end
          end

          context 'tracing_in_rectangular_coordinates' do
            it 'should convert the "R" datasets to rectangular coordinates' do
              expect(tracing_in_rect([2416, 2410, 2425, 2429]))
                .to eq [[2416, 0], [0, 2410], [-2425, 0], [0, -2429]]

              expect(tracing_in_rect([2476, 2478, 2481, 2483]))
                .to eq [[2476, 0], [0, 2478], [-2481, 0], [0, -2483]]
            end

            def tracing_in_rect radius_data
              TracingDataset.new(radius_data: radius_data, trcfmt_values: ['1']).in_rectangular_coordinates
            end
          end
        end
      end
    end
  end
end
