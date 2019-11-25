module LensProtocol
  module OMA
    class Record
      attr_reader :label

      # An array of coerced values (the ones separated with semicolon)
      attr_reader :values

      def initialize label:, values:
        @label = label
        @values = values
      end
    end
  end
end
