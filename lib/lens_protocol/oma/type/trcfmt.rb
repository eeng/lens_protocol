module LensProtocol
  module OMA
    module Type
      class Trcfmt < Base
        def parse message, label, values, _opts
          side = values[3] == 'R' ? 0 : 1
          message.add_record_side_values(label, side, values).set_context(:last_trcfmt_side, side)
        end
      end
    end
  end
end
