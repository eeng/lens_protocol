module LensProtocol
  module OMA
    module Types
      class Chiral < Type
        def parse line, next_lines
          values = make_chiral parse_values line.data
          [values, next_lines]
        end

        def wrap value, _message_hash, _label
          make_chiral Array(value)
        end

        def format label, values
          data = values.select(&:present?).empty? ? '' : format_values(values)
          build_line label, data
        end

        private

        def make_chiral values
          if values.size <= 1
            [values[0], values[0]]
          else
            values[0..1]
          end
        end
      end
    end
  end
end
