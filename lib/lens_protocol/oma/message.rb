module LensProtocol
  module OMA
    class Message
      attr_reader :records

      # Builds a message from a hash of record labels to record value.
      def self.from_hash hash
        hash.reduce new do |message, (label, value)|
          message.add_record(label, value)
        end
      end

      def initialize records: {}, context: {}
        @records = records
        @context = context
      end

      def add_record label, value
        @records[label] ||= Record.new(label: label, value: value)
        self
      end

      def add_record_or_insert_values label, values
        @records[label] ||= Record.new(label: label, value: [])
        @records[label].value << values
        self
      end

      def add_record_or_concat_values label, values
        @records[label] ||= Record.new(label: label, value: [])
        @records[label].value.concat values
        self
      end

      def add_record_side_values label, side, values
        @records[label] ||= Record.new(label: label, value: [[], []])
        @records[label].value[side].concat values
        self
      end

      def set_context key, value
        @context[key] = value
        self
      end

      def value_of label
        @records[label].value if include? label
      end

      # Returns +true+ if the message contains a record with the given label
      def include? label
        @records.key? label
      end

      def context key
        @context[key]
      end

      def to_hash
        Hash[*@records.flat_map { |label, record| [label, record.value] }]
      end

      # Returns the "R" reconds decoded radiuses according to the tracing format.
      def radius_data
        return [] unless value_of('TRCFMT') && value_of('R')
        [0, 1].map do |side|
          format_number, = value_of('TRCFMT')[side]
          case format_number.to_i
          when 0 # side not present
            []
          when 1 # ASCII format
            value_of('R')[side]
          else # unknown format
            return []
          end
        end
      end

      # Converts the "R" record values to polar coordinates.
      def tracing_in_polar_coordinates
        radius_data.map { |radiuses| radiuses_to_polar radiuses }
      end

      def radiuses_to_polar radiuses
        radiuses.map.with_index { |r, i| [i * 2 * Math::PI / radiuses.size, r] }
      end

      # Converts the "R" record values to rectangular coordinates.
      def tracing_in_rectangular_coordinates
        radius_data.map { |radiuses| radiuses_to_rectangular radiuses }
      end

      def radiuses_to_rectangular radiuses
        radiuses_to_polar(radiuses).map { |(a, r)| [r * Math.cos(a), r * Math.sin(a)].map { |v| v.round 2 } }
      end

      # Returns an array of SVG strings, one for each side. If the tracing format is not recognized
      # or there is no tracing data, returns an empty array.
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

      def to_s
        OMA.format self
      end
    end
  end
end
