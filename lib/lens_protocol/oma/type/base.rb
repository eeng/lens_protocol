module LensProtocol
  module OMA
    module Type
      class Base
        def initialize chiral: false
          @chiral = chiral
        end

        # TODO maybe receive q line instead to make it more format like?
        def parse message, label, values, _opts
          message.add_record label, values
        end

        # @param [Record]
        # @return [Array of lines or a single one]
        def format record, _message
          format_single_line record.label, format_values(record.values)
        end

        private

        def format_single_line label, values
          "#{label}=#{values.join(';')}"
        end

        def format_values values
          values
        end
      end
    end
  end
end
