module LensProtocol
  module OMA
    module Types
      class Array < Type
        def parse line, next_lines
          values = parse_values line.data
          [values, next_lines]
        end

        def wrap value, _message_hash, label
          raise ValidationError, "#{label}: Expected an array of values. Got #{value}" unless value.is_a?(::Array)
          value
        end

        def format label, values
          build_line label, format_values(values)
        end
      end
    end
  end
end
