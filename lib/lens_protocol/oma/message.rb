module LensProtocol
  module OMA
    class Message
      def initialize records: {}, context: {}
        @records = records
        @context = context
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

      def self.from_hash hash
        hash.reduce new do |message, (label, values)|
          message.add_record(label, values)
        end
      end

      def to_hash
        Hash[*@records.flat_map { |label, record| [label, record.values] }]
      end

      def tracing_in_polar_coordinates
        values_of('R').map { |radiuses| radiuses_to_polar radiuses }
      end

      def radiuses_to_polar radiuses
        radiuses.map.with_index { |r, i| [i * 2 * Math::PI / radiuses.size, r] }
      end

      def tracing_in_rectangular_coordinates
        values_of('R').map { |radiuses| radiuses_to_rectangular radiuses }
      end

      def radiuses_to_rectangular radiuses
        radiuses_to_polar(radiuses).map { |(a, r)| [r * Math.cos(a), r * Math.sin(a)].map { |v| v.round 2 } }
      end

      def to_svg
        SVG.from_message self
      end
    end
  end
end
