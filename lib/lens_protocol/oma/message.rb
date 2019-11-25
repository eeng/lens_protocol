module LensProtocol
  module OMA
    class Message
      def initialize
        @records = {}
      end

      def []= label, record
        @records[label] = record
      end

      def [] label
        @records[label]
      end

      def to_hash
        Hash[*@records.flat_map { |label, record| [label, record.values] }]
      end
    end
  end
end
