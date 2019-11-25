module LensProtocol
  module OMA
    class Message
      attr_reader :context

      def initialize
        @records = {}
        @context = {}
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
