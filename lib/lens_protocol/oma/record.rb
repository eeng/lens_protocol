module LensProtocol
  module OMA
    class Record
      attr_reader :label, :values

      def initialize label:, values:
        @label = label
        @values = values
      end
    end
  end
end
