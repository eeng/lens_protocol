module LensProtocol
  RSpec.describe OMA do
    it 'parsing and formatting should return the same original content' do
      assert_parse_and_format_cosistent 'R360_1'
      assert_parse_and_format_cosistent 'R360_2'
      assert_parse_and_format_cosistent 'R1000_1', types: {
        'DBL' => OMA::Types::Single.new(value_type: :integer),
        'ZTILT' => OMA::Types::Single.new(value_type: :integer)
      }
      assert_parse_and_format_cosistent 'R1000_2', types: {
        'DBL' => OMA::Types::Single.new(value_type: :integer),
        'ZTILT' => OMA::Types::Single.new(value_type: :integer)
      }
      assert_parse_and_format_cosistent 'TRCFMT6', types: {
        'DBL' => OMA::Types::Single.new(value_type: :numeric, decimals: 2),
        'BEVM' => OMA::Types::Chiral.new(value_type: :numeric, decimals: 2)
      }
    end

    def assert_parse_and_format_cosistent filename, types: {}
      file = File.read("examples/oma/#{filename}.oma")
      result = OMA.format(OMA.parse(file, types: types), types: types)
      expect(nle(result)).to eq nle(file)
    end

    it 'generate should create a Message from a hash' do
      expect(OMA.generate('A' => 1)).to be_a OMA::Message
    end

    def nle text
      text.gsub /\r\n?/, "\n"
    end
  end
end
