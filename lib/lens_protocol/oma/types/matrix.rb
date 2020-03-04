module LensProtocol
  module OMA
    module Types
      class Matrix < Type
        def parse line, next_lines
          same_label_lines, next_lines = next_lines.partition { |other_line| other_line.label == line.label }
          values = [line, *same_label_lines].map { |line| parse_values line.data }
          [values, next_lines]
        end

        def format label, values
          values.map { |v| build_line label, format_values(v) }
        end
      end
    end
  end
end
