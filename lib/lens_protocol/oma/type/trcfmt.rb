module LensProtocol
  module OMA
    module Type
      class Trcfmt < Base
        def parse line, message
          label, values = label_and_values line
          side = side_position_from_trcfmt values
          message.add_record_side_values(label, side, values).set_context(:last_trcfmt_side, side)
        end

        def format record, message
          record.values.select(&:any?).flat_map do |values|
            trcfmt_line = format_single_line(record.label, values)

            side = side_position_from_trcfmt values
            r_lines = message.values_of('R')[side].each_slice(10).map do |group|
              format_single_line('R', group)
            end

            [trcfmt_line, *r_lines]
          end
        end

        def side_position_from_trcfmt values
          values[3] == 'R' ? 0 : 1
        end
      end
    end
  end
end
