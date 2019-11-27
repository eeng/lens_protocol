module LensProtocol
  module OMA
    module Type
      class R < Base
        def parse line, message
          label, values = label_and_values line
          side = message.context(:last_trcfmt_side) or raise ParsingError.new('Could not found a corresponding TRCFMT record', line)
          message.add_record_side_values(label, side, values.map(&:to_i))
        end

        def format _record, _message
          [] # Formatted in Type::Trcfmt
        end
      end
    end
  end
end
