module LensProtocol
  module OMA
    module Type
      class R < Base
        def parse line, message
          label, values = label_and_values line
          trcfmt = message.context(:last_trcfmt) or return message
          values = Trcfmt.number(trcfmt) == 1 ? values.map(&:to_i) : values
          message.add_record_side_values(label, Trcfmt.side_pos(trcfmt), values)
        end

        def format _record, _message
          [] # Formatted in Type::Trcfmt
        end
      end
    end
  end
end
