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
        values = data.split(';', -1)
        type = TYPES[label]
        message = type.parse(message, label, values)
        unless message.is_a?(Message)
          raise ParsingError, "#{type.class}#parse method should return the message. Got #{message.class}."
        end
        message
      end

      def normalize_line_endings str
        str.gsub /\r\n?/, "\n"
      end
    end
  end
end
