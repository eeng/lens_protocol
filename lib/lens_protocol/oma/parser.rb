module LensProtocol
  module OMA
    class Parser
      def self.parse oma_str
        new.parse oma_str
      end

      def parse oma_str
        normalize_line_endings(oma_str)
          .split("\n")
          .reduce(Message.new) { |message, line| parse_line message, line }
      end

      private

      def parse_line message, line
        label, data = line.split('=')
        values = data.to_s.split(';', -1)
        TYPES[label].parse(message, label, values, line: line)
      end

      def normalize_line_endings str
        str.gsub /\r\n?/, "\n"
      end
    end
  end
end
