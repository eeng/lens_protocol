module LensProtocol
  module OMA
    module Type
      class Integer < Base
        def parse_values values
          values.map { |str| Integer(str) rescue nil }
        end

        def format_values values
          values.map { |v| v.round if v }
        end
      end
    end
  end
end
