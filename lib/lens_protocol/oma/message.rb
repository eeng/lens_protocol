module LensProtocol
  module OMA
    class Message
      def initialize
        @records = {}
        @context = {}
      end

      def add_record label, values
        @records[label] = Record.new(label: label, values: values)
        self
      end

      def add_record_side_values label, side, values
        @records[label] ||= Record.new(label: label, values: [[], []])
        @records[label].values[side].concat values
        self
      end

      def set_context key, value
        @context[key] = value
        self
      end

      def values_of label
        @records[label].values
      end

      def context key
        @context[key]
      end

      def to_hash
        Hash[*@records.flat_map { |label, record| [label, record.values] }]
      end
    end
  end
end
