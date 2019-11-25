module LensProtocol
  module OMA
    module Type
      class R < Base
        def parse message, label, values
          side = message.context[:last_trcfmt_side] or raise ParsingError, 'Could not found a corresponding TRCFMT record'
          message[label] ||= Record.new(label: label, values: [[], []])
          message[label].values[side].concat values.map(&:to_i)
          message
        end
      end
    end
  end
end
