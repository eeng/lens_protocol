module LensProtocol
  module OMA
    module Type
      class Base
        def initialize mode: :single_value
          @mode = mode
        end

        # Given a line and a message produces a new message with the record(s) corresponding to that line added to the message
        # @return [Message]
        def parse line, message
          label, data = label_and_data line
          case @mode
          when :single_value
            message.add_record label, parse_value(data)
          when :array_of_values
            message.add_record_or_concat_values label, parse_values(data)
          when :chiral
            message.add_record label, parse_chiral(data)
          when :matrix_of_values
            message.add_record_or_insert_values label, parse_values(data)
          else
            raise ArgumentError, "Mode #{@mode} not supported"
          end
        end

        # @return [Array of lines or a single one]
        def format record, _message
          case @mode
          when :single_value
            format_line record.label, [format_value(record.value)]
          when :array_of_values
            format_line record.label, format_values(record.value)
          when :chiral
            format_line record.label, format_chiral(record.value)
          when :matrix_of_values
            record.value.map do |value|
              format_line record.label, format_values(value)
            end
          else
            raise ArgumentError, "Mode #{@mode} not supported"
          end
        end

        private

        def label_and_data line
          label, data = line.split('=')
          [label, data]
        end

        def label_and_values line
          label, data = label_and_data line
          [label, parse_values(data)]
        end

        def parse_values data
          data.split(';', -1).map { |value| parse_value value }
        end

        def parse_value value
          value if value != '?'
        end

        def parse_chiral values
          make_chiral parse_values values
        end

        def make_chiral values
          if values.size == 1
            [values[0], values[0]]
          else
            values[0..1]
          end
        end

        def format_line label, values
          "#{label}=#{values.join(';')}"
        end

        def format_value value
          value
        end

        def format_values values
          values = values.is_a?(Array) ? values : [values]
          values.map { |v| format_value(v) }
        end

        def format_chiral value
          make_chiral format_values value
        end
      end
    end
  end
end
