module LensProtocol
  module OMA
    module Type
      class Numeric < Base
        def initialize decimals: 2, **opts
          super **opts
          @decimals = decimals
        end

        def parse message, label, values
          values = values.map { |str| Float(str) rescue nil }
          super
        end
      end
    end
  end
end
