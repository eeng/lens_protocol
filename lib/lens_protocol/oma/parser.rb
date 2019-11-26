module LensProtocol
  module OMA
    class Parser
      def parse oma_str, types: {}
        types = TYPES.merge(types)
        normalize_line_endings(oma_str)
          .split("\n")
          .reduce(Message.new) { |message, line| parse_line line, message, types }
      end

      private

      def parse_line line, message, types
        label, = line.split('=')
        types[label].parse(line, message)
      end

      def normalize_line_endings str
        str.to_s.gsub /\r\n?/, "\n"
      end
    end
  end
end
