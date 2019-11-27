module LensProtocol
  module OMA
    class Formatter
      # Generates the OMA string from a Message
      def format message, line_separator: "\r\n", start_of_message: '', end_of_message: '', **opts
        [
          start_of_message,
          format_lines(message, **opts).join(line_separator),
          line_separator,
          end_of_message
        ].join
      end

      def format_lines message, types: {}, without_empty_records: false
        types = TYPES.merge(types)
        lines = message.records.values.flat_map do |record|
          types[record.label].format(record, message)
        end
        lines = lines.reject { |line| line.end_with?('=') } if without_empty_records
        lines
      end
    end
  end
end
