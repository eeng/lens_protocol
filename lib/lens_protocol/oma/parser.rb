module LensProtocol
  module OMA
    class Parser
      def self.parse oma_str
        new.parse oma_str
      end

      def parse oma_str
        Message.new records: normalize_line_endings(oma_str).split("\n").map { |line| parse_line line }
      end

      private

      def parse_line line
        label, value = line.split('=')
        Record.new label: label, unparsed_value: value
      end

      def normalize_line_endings str
        str.gsub /\r\n?/, "\n"
      end
    end
  end
end
