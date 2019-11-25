module LensProtocol
  module OMA
    module Type
      class Trcfmt < Base
        def parse message, label, values, _opts
          side = values[3] == 'R' ? 0 : 1
          message[label] ||= Record.new(label: label, values: [nil, nil])
          message[label].values[side] = values
          message.context[:last_trcfmt_side] = side
          message
        end
      end
    end
  end
end
