module LensProtocol
  module OMA
    class Message
      attr_reader :records

      # Builds a message from a hash of record labels to record values.
      def self.from_hash hash
        hash.reduce new do |message, (label, values)|
          message.add_record(label, values)
        end
      end

      def initialize records: {}, context: {}
        @records = records
        @context = context
      end

      def add_record label, values
        @records[label] = Record.new(label: label, values: values)
        self
      end

      def add_record_values label, values
        @records[label] ||= Record.new(label: label, values: [])
        @records[label].values << values
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
        @records[label].values if include? label
      end

      # Returns +true+ if the message contains a record with the given label
      def include? label
        @records.key? label
      end

      def context key
        @context[key]
      end

      def to_hash
        Hash[*@records.flat_map { |label, record| [label, record.values] }]
      end

      # Converts the "R" record values to polar coordinates.
      def tracing_in_polar_coordinates
        (values_of('R') || []).map { |radiuses| radiuses_to_polar radiuses }
      end

      def radiuses_to_polar radiuses
        radiuses.map.with_index { |r, i| [i * 2 * Math::PI / radiuses.size, r] }
      end

      # Converts the "R" record values to rectangular coordinates.
      def tracing_in_rectangular_coordinates
        (values_of('R') || []).map { |radiuses| radiuses_to_rectangular radiuses }
      end

      def radiuses_to_rectangular radiuses
        radiuses_to_polar(radiuses).map { |(a, r)| [r * Math.cos(a), r * Math.sin(a)].map { |v| v.round 2 } }
      end

      # Returns an array of SVG strings, one for each side
      def to_svg **opts
        SVG.from_message self, **opts
      end

      # Similarly to +Hash#merge+ returns a new message containing the records of +this+ and the records of +other+
      # keeping the ones in +other+ if the labels colides.
      def merge other
        Message.new records: @records.merge(other.records)
      end

      # Returns a new message without the records of the given labels.
      # @param labels [Array]
      def except labels
        Message.new records: @records.reject { |label, _| labels.include? label }
      end

      # Returns a new message with only the records of the given labels.
      # @param labels [Array]
      def only labels
        Message.new records: @records.slice(*labels)
      end
    end
  end
end
