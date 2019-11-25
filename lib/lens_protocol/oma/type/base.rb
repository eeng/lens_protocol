module LensProtocol
  module OMA
    module Type
      class Base
        def initialize chiral: false
          @chiral = chiral
        end

        def parse message, label, values, _opts
          message[label] = Record.new(label: label, values: values)
          message
        end
      end
    end
  end
end
