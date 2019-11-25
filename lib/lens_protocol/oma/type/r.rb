module LensProtocol
  module OMA
    module Type
      class R < Base
        def parse message, label, values, line:
          side = message.context(:last_trcfmt_side) or raise ParsingError.new(line, 'Could not found a corresponding TRCFMT record')
          message.add_record_side_values(label, side, values.map(&:to_i))
        end
      end
    end
  end
end
