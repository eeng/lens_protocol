module LensProtocol
  module OMA
    module Types
      class Ignored < Type
        def parse _line, next_lines
          [nil, next_lines]
        end

        def wrap _value, _message, _label
          :ignored
        end
      end
    end
  end
end
