module LensProtocol
  module OMA
    class Record
      attr_reader :label

      attr_reader :value

      def initialize label:, value:
        @label = label
        @value = value
      end

      def empty?
        Array(value).select(&:present?).empty?
      end
    end
  end
end
