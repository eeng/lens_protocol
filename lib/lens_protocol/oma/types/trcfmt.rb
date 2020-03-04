module LensProtocol
  module OMA
    module Types
      class Trcfmt < Type
        def parse line, next_lines
          dataset1, next_lines = extract_tracing_dataset [line, *next_lines]
          dataset2, next_lines = extract_tracing_dataset next_lines

          datasets = [dataset1, dataset2].compact
          value = [
            datasets.detect { |ds| ds.side == 'R' },
            datasets.detect { |ds| ds.side == 'L' }
          ]

          [value, next_lines]
        end

        def wrap value, message_hash, _label
          right_side, left_side = value
          [
            build_tracing_dataset(right_side, message_hash),
            build_tracing_dataset(left_side, message_hash)
          ]
        end

        def format label, chiral_value
          chiral_value.compact.flat_map do |value|
            [
              build_line(label, format_values(value.trcfmt_values)),
              *value.radius_data.each_slice(10).map { |vs| build_line('R', format_values(vs)) }
            ]
          end
        end

        private

        def extract_tracing_dataset lines
          line, *next_lines = lines.drop_while { |line| line.label != 'TRCFMT' }

          if line
            trcfmt_values = parse_values line.data

            radius_data = next_lines
              .take_while { |line| line.label == 'R' }
              .flat_map { |line| parse_radius_data line.data, trcfmt_values[0] }

            dataset = Values::TracingDataset.new(trcfmt_values: trcfmt_values, radius_data: radius_data)
            [dataset, next_lines.drop_while { |line| line.label == 'R' }]
          else
            [nil, []]
          end
        end

        def parse_radius_data data, format
          if format == '1'
            parse_values data, :integer
          else
            data
          end
        end

        def build_tracing_dataset value, message_hash
          return unless value

          _, _, _, side, = value
          raise ValidationError, "Invalid TRCFMT value '#{value}'" unless %w[L R].include?(side)

          r_values = message_hash['R']
          raise ValidationError, "Invalid R value '#{r_values}'" unless r_values && r_values.size == 2

          radius_data = r_values[side == 'R' ? 0 : 1]
          Values::TracingDataset.new(trcfmt_values: value, radius_data: radius_data)
        end
      end
    end
  end
end
