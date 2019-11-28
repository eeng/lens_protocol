module LensProtocol
  RSpec.describe OMA do
    it 'parse(format(parse(file))) == parse(file)' do
      Dir['examples/oma/*.oma'].each do |filename|
        file = File.read(filename)
        expect(OMA.parse(OMA.format(OMA.parse(file))).to_hash).to eq OMA.parse(file).to_hash
      end
    end
  end
end