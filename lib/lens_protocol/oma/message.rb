module LensProtocol
  module OMA
    class Message
      attr_reader :records

      # Builds a message from a hash of record labels to record value.
      def self.from_hash *args
        OMA.generate *args
      end

      def initialize records: {}
        @records = records
      end

      def add_record label, value
        @records[label] ||= Record.new(label: label, value: value)
        self
      end

      def value_of label, default = nil
        if include? label
          @records[label].value
        else
          default
        end
      end

      # Returns +true+ if the message contains a record with the given label
      def include? label
        @records.key? label
      end

      def empty?
        @records.empty?
      end

      def to_hash
        Hash[*@records.flat_map { |label, record| [label, record.value] }]
      end

      # Converts the "R" record values to polar coordinates.
      def tracing_in_polar_coordinates
        value_of('TRCFMT', []).map { |tracing_dataset| tracing_dataset&.in_polar_coordinates || [] }
      end

      # Converts the "R" record values to rectangular coordinates.
      def tracing_in_rectangular_coordinates
        value_of('TRCFMT', []).map { |tracing_dataset| tracing_dataset&.in_rectangular_coordinates || [] }
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

      def remove_empty_records
        Message.new records: @records.reject { |_, r| r.empty? }
      end

      def to_s
        OMA.format self
      end
    end
  end
end
