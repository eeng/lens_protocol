module LensProtocol
  module OMA
    module Type
      class Trcfmt < Base
        def parse line, message
          label, values = label_and_values line
          side_pos = Trcfmt.side_pos values
          message.add_record_side_values(label, side_pos, values).set_context(:last_trcfmt, values)
        end

        def format record, message
          Array(record.value).select { |v| v&.any? }.flat_map do |values|
            trcfmt_line = format_line(record.label, values)

            side_pos = Trcfmt.side_pos values
            r_lines = message.value_of('R', [[], []])[side_pos].each_slice(10).map do |group|
              format_line('R', group)
            end

            [trcfmt_line, *r_lines]
          end
        end

        def self.side_pos values
          values[3] == 'R' ? 0 : 1
        end

        def self.number values
          values[0].to_i
        end
      end
    end
  end
end
