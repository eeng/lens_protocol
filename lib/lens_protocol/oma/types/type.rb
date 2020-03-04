module LensProtocol
  module OMA
    module Types
      class Type
        def initialize value_type: :string, decimals: nil
          @value_type = value_type
          @decimals = decimals
        end

        # Receives the current line and the lines after that.
        # Must return the parsed value to store on the message, and the array of (possibly filtered) next lines.
        def parse _line, _next_lines
          raise NotImplementedError, self
        end

        # Used when building a message from a hash. Validations may be placed in the subclasses.
        # TODO The message hash is only used for records like TRCFMT that need to access the R values, but having
        # the R at the same level in the hash would not allow for building messages with TRCFMT and STHKFMT.
        def wrap value, _message_hash, _label
          value
        end

        # Receives a record label and value.
        # Must return one line or and array of them.
        def format _label, _value
          raise NotImplementedError, self
        end

        private

        def parse_value value, type = @value_type
          case type
          when :string
            value if value != '?'
          when :integer
            Integer(value) rescue Float(value).round rescue nil
          when :numeric
            Float(value) rescue nil
          else
            raise "Value type '#{type}' not supported"
          end
        end

        def parse_values data, type = @value_type
          data.split(';', -1).map { |value| parse_value value, type }
        end

        def format_value value, type = @value_type
          return nil unless value

          case type
          when :string
            value
          when :integer
            value.round
          when :numeric
            @decimals ? "%.#{@decimals}f" % value : value
          else
            raise "Value type '#{type}' not supported"
          end
        end

        def format_values values, type = @value_type
          values = values.is_a?(::Array) ? values : [values]
          values.map { |v| format_value v, type }.join(';')
        end

        def build_line label, data
          Line.new label: label, data: data
        end
      end
    end
  end
end
