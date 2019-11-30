module LensProtocol
  RSpec.describe OMA do
    it 'parse(format(parse(file))) == parse(file)' do
      Dir['examples/oma/*.oma'].each do |filename|
        file = File.read(filename)
        expect(OMA.parse(OMA.format(OMA.parse(file))).to_hash).to eq OMA.parse(file).to_hash
      end
    end

    it 'file == format(parse(file))' do
      file = File.read('examples/oma/TRCFMT6.oma')
      result = OMA.format(OMA.parse(file),
        types: {
          'DBL' => OMA::Type::Numeric.new(decimals: 2),
          'BEVM' => OMA::Type::Numeric.new(decimals: 2, mode: :chiral)
        })
      expect(nle(result)).to eq nle(file)

      file = File.read('examples/oma/R360_1.oma')
      result = OMA.format(OMA.parse(file))
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
