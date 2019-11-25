module LensProtocol
  module OMA
    module Type
      class Base
        def initialize chiral: false
          @chiral = chiral
        end

        def parse message, label, values, _opts
          message.add_record label, values
        end
      end
    end
  end
end
