module LensProtocol
  module OMA
    class Message
      attr_reader :records

      def initialize records:
        @records = records
      end

      def to_hash
        @records.each_with_object({}) do |record, hash|
          hash[record.label] = record.unparsed_value
        end
      end
    end
  end
end
