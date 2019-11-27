module LensProtocol
  module OMA
    class Record
      attr_reader :label

      # May hold a single value, an array of values (on multi-value and chiral records), or an array of array of values (in R records for example)
      attr_reader :value

      def initialize label:, value:
        @label = label
        @value = value
      end
    end
  end
end
