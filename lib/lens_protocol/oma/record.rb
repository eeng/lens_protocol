module LensProtocol
  module OMA
    class Record
      attr_reader :label, :unparsed_value

      def initialize label:, unparsed_value:
        @label = label
        @unparsed_value = unparsed_value
      end
    end
  end
end
