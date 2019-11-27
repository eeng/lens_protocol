module LensProtocol
  module OMA
    module Type
      class Integer < Base
        def parse_value value
          Integer(value) rescue Float(value).round rescue nil
        end

        def format_value value
          value.round if value
        end
      end
    end
  end
end
