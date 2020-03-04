module LensProtocol
  module OMA
    module Types
      class Single < Type
        def parse line, next_lines
          value = parse_value line.data
          [value, next_lines]
        end

        def wrap value, _message_hash, label
          raise ValidationError, "#{label}: Expected a single value. Got #{value}" if value.respond_to?(:each)
          value
        end

        def format label, value
          build_line label, format_value(value)
        end
      end
    end
  end
end
