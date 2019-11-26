module LensProtocol
  module OMA
    module Type
      class Base
        def initialize chiral: false
          @chiral = chiral
        end

        # Given a line and a message produces a new message with the record(s) corresponding to that line added to the message
        def parse line, message
          label, values = label_and_values line
          message.add_record label, parse_values(values)
        end

        # @param [Record]
        # @return [Array of lines or a single one]
        def format record, _message
          format_single_line record.label, format_values(record.values)
        end

        private

        def label_and_values line
          label, data = line.split('=')
          values = data.to_s.split(';', -1)
          [label, values]
        end

        def parse_values values
          values
        end

        def format_single_line label, values
          "#{label}=#{values.join(';')}"
        end

        def format_values values
          values
        end
      end
    end
  end
end
