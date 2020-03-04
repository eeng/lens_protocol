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

      def format_lines message, types: {}
        types = TYPES.merge(types)
        message.records.flat_map do |label, record|
          format_record label, record.value, types
        end
      end

      private

      def format_record label, value, types
        lines = types[label].format(label, value)
        lines = lines.is_a?(Array) ? lines : [lines]
        lines.map &:to_s
      end
    end
  end
end
