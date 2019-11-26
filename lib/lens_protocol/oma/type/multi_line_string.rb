module LensProtocol
  module OMA
    module Type
      class MultiLineString < Base
        def parse message, label, values, _opts
          message.add_record_values(label, values)
        end
      end
    end
  end
end
