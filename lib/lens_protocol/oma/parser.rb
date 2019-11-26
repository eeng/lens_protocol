module LensProtocol
  module OMA
    class Parser
      def parse oma_str, types: {}
        normalize_line_endings(oma_str)
          .split("\n")
          .reduce(Message.new) { |message, line| parse_line message, line, TYPES.merge(types) }
      end

      private

      def parse_line message, line, types
        label, data = line.split('=')
        values = data.to_s.split(';', -1)
        types[label].parse(message, label, values, line: line)
      end

      def normalize_line_endings str
        str.gsub /\r\n?/, "\n"
      end
    end
  end
end
