module LensProtocol
  module OMA
    module Types
      module Values
        class TracingDataset
          attr_reader :trcfmt_values, :radius_data

          def initialize trcfmt_values:, radius_data: []
            @trcfmt_values = trcfmt_values
            @radius_data = radius_data
          end

          def side
            trcfmt_values[3]
          end

          def format
            trcfmt_values[0]
          end

          def side_pos
            side == 'R' ? 0 : 1
          end

          # Converts the radius data record values to polar coordinates.
          def in_polar_coordinates
            return [] unless recognized_format?
            radius_data.map.with_index { |r, i| [i * 2 * Math::PI / radius_data.size, r] }
          end

          def in_rectangular_coordinates
            in_polar_coordinates.map { |(a, r)| [r * Math.cos(a), r * Math.sin(a)].map { |v| v.round 2 } }
          end

          def recognized_format?
            format == '1'
          end
        end
      end
    end
  end
end
