module LensProtocol
  module OMA
    class Record
      DEFINITIONS = Hash.new(type: :string).merge(
        'FTYP' => {type: :integer},
        'ETYP' => {type: :integer},
        'DBL' => {type: :numeric, decimals: 2},
        'HBOX' => {type: :numeric, chiral: true, decimals: 2},
        'VBOX' => {type: :numeric, chiral: true, decimals: 2},
        'CRIB' => {type: :numeric, chiral: true, decimals: 2},
        'FED' => {type: :numeric, chiral: true, decimals: 2},
        'NPD' => {type: :numeric, chiral: true, decimals: 2},
        'MPD' => {type: :numeric, chiral: true, decimals: 0},
        'IPD' => {type: :numeric, chiral: true, decimals: 2},
        'OCHT' => {type: :numeric, chiral: true, decimals: 2},
        'SEGHT' => {type: :numeric, chiral: true, decimals: 2},
        'LDDRSPH' => {type: :numeric, chiral: true},
        'LDDRCYL' => {type: :numeric, chiral: true},
        'LDDRAX' => {type: :numeric, chiral: true},
        'LDNRSPH' => {type: :numeric, chiral: true},
        'LDNRCYL' => {type: :numeric, chiral: true},
        'LDNRAX' => {type: :numeric, chiral: true},
        'LDADD' => {type: :numeric, chiral: true},
        'OPTFRNT' => {type: :numeric, chiral: true},
        'MINFRT' => {type: :numeric, chiral: true},
        'MAXFRT' => {type: :numeric, chiral: true},
        'CTHICK' => {type: :numeric, chiral: true, decimals: 3},
        'FCSGIN' => {type: :numeric, chiral: true, decimals: 2},
        'FCSGUP' => {type: :numeric, chiral: true, decimals: 2},
        'FCOCIN' => {type: :numeric, chiral: true, decimals: 2},
        'FCOCUP' => {type: :numeric, chiral: true, decimals: 2},
        'SGOCIN' => {type: :numeric, chiral: true, decimals: 2},
        'SGOCUP' => {type: :numeric, chiral: true, decimals: 2},
        'FRNT' => {type: :numeric, chiral: true, decimals: 2},
        'SPH' => {type: :numeric, chiral: true, decimals: 2},
        'CYL' => {type: :numeric, chiral: true, decimals: 2},
        'AX' => {type: :numeric, chiral: true, decimals: 2},
        'ADD' => {type: :numeric, chiral: true, decimals: 2},
        'MBASE' => {type: :numeric, chiral: true, decimals: 2},
        'LIND' => {type: :numeric, chiral: true, decimals: 3},
        'PRVM' => {type: :numeric, chiral: true, decimals: 2},
        'PRVA' => {type: :numeric, chiral: true, decimals: 1},
        '_PRVM1' => {type: :numeric, chiral: true, decimals: 1},
        '_PRVM2' => {type: :numeric, chiral: true, decimals: 1},
        '_PRVA1' => {type: :numeric, chiral: true, decimals: 0},
        '_PRVA2' => {type: :numeric, chiral: true, decimals: 0},
        'BCTHK' => {type: :numeric, chiral: true, decimals: 2},
        'BACK' => {type: :numeric, chiral: true, decimals: 2},
        'DIA' => {type: :numeric, chiral: true, decimals: 2},
        'LMATID' => {type: :integer, chiral: true},
        'LNAM' => {type: :string, chiral: true},
        'LMATTYPE' => {type: :string, chiral: true},
        'LDVEN' => {type: :string, chiral: true},
        'LDNAM' => {type: :string, chiral: true},
        'FWD' => {type: :string, chiral: true},
        'OPC' => {type: :string, chiral: true},
        'TINT' => {type: :string, chiral: true},
        'ACOAT' => {type: :string, chiral: true},
        '_LLVAL' => {type: :integer, chiral: true},
        'BVD' => {type: :integer, chiral: true},
        'PANTO' => {type: :integer, chiral: true},
        'ZTILT' => {type: :integer, chiral: true},
        '_CTO' => {type: :integer, chiral: true}
      )

      attr_reader :label

      # Stores de original string value of the record, i.e. for TRCFMT=1;1000;E;R;P it will store 1;1000;E;R;P
      attr_reader :raw_value

      # An array of coerced values (the ones separated with semicolon)
      attr_reader :values

      def initialize label:, raw_value:
        @label = label
        @raw_value = raw_value
        @values = raw_value.split(';', -1).map { |v| parse_raw_value v }
      end

      def chiral?
        DEFINITIONS[label][:chiral]
      end

      def type
        DEFINITIONS[label][:type]
      end

      def integer?
        type == :integer
      end

      def numeric?
        type == :numeric
      end

      def right_value
        values[0] if chiral?
      end

      def left_value
        values[1] if chiral?
      end

      private

      def parse_raw_value str
        if str.strip.empty?
          nil
        elsif integer?
          Integer(str) rescue nil
        elsif numeric?
          Float(str) rescue nil
        else
          str
        end
      end
    end
  end
end
