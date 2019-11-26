module LensProtocol
  module OMA
    module Type
      class MultiLineString < Base
        def parse line, message
          label, values = label_and_values line
          message.add_record_values label, values
        end

        def format record, _message
          record.values.map do |line_values|
            format_single_line record.label, line_values
          end
        end
      end
    end
  end
end
