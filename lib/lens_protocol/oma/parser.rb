module LensProtocol
  module OMA
    class Parser
      def parse oma_str, types: {}
        types = TYPES.merge(types)
        lines = convert_to_structured_lines normalize_line_endings(oma_str).split("\n")
        parse_lines lines, types, Message.new
      end

      private

      def normalize_line_endings str
        str.to_s.gsub /\r\n?/, "\n"
      end

      def convert_to_structured_lines lines
        lines.map { |line| Line.parse line }
      end

      def parse_lines lines, types, message
        line, *next_lines = lines
        if line
          value, next_lines = types[line.label].parse(line, next_lines)
          message.add_record(line.label, value) if value
          parse_lines next_lines, types, message
        else
          message
        end
      end
    end
  end
end
