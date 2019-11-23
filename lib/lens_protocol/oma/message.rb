module LensProtocol
  module OMA
    class Message
      attr_reader :records

      def initialize records:
        @records = records
      end

      def [] label
        records_hash[label]
      end

      def to_hash
        Hash[*records_hash.flat_map { |label, record| [label, record.values] }]
      end

      def records_hash
        @records_hash ||= @records.each_with_object({}) do |record, hash|
          hash[record.label] = record
        end
      end
    end
  end
end
