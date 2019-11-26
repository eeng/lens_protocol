module LensProtocol
  module OMA
    module Type
      class Numeric < Base
        def initialize decimals: nil, **opts
          super **opts
          @decimals = decimals
        end

        def parse_values values
          values.map { |str| Float(str) rescue nil }
        end

        def format_values values
          values.map do |v|
            if v && @decimals
              "%.#{@decimals}f" % v
            else
              v
            end
          end
        end
      end
    end
  end
end
