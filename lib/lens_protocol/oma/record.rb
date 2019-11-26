module LensProtocol
  module OMA
    class Record
      attr_reader :label, :values

      def initialize label:, values:
        @label = label
        @values = values
      end

      def to_s
        "#{label}=#{values.join(';')}"
      end
    end
  end
end
