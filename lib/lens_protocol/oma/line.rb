module LensProtocol
  module OMA
    Line = Struct.new(:label, :data, :raw, keyword_init: true) do
      def self.parse raw_line
        raise ParsingError.new('The label separator is missing', raw_line) unless raw_line.include?('=')

        label, data = raw_line.split('=', -1)
        Line.new label: label, data: data, raw: raw_line
      end

      def to_s
        "#{label}=#{data}"
      end
    end
  end
end
