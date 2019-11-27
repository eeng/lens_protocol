module LensProtocol
  module OMA
    module Type
      class Numeric < Base
        def initialize decimals: nil, **opts
          super **opts
          @decimals = decimals
        end

        def parse_value value
          Float(value) rescue nil
        end

        def format_value value
          if value && @decimals
            "%.#{@decimals}f" % value
          else
            value
          end
        end
      end
    end
  end
end
