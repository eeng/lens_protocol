module LensProtocol
  RSpec.describe SVG do
    context 'from_message' do
      it 'should return an array of svgs (on for each side)' do
        message = OMA::Message.from_hash(
          'R' => [
            [2416, 2410, 2425, 2429],
            [2476, 2478, 2481, 2483]
          ]
        )
        right_svg, left_svg = SVG.from_message(message).map { |svg| parse_xml svg }
        expect(right_svg.css('svg').size).to eq 1
        expect(left_svg.css('svg').size).to eq 1
      end

      it 'should draw a polygon with the points Y coordinate inverted' do
        message = OMA::Message.from_hash('R' => [[2416, 2410, 2425, 2429], []])
        svg = parse_xml(SVG.from_message(message).first)
        expect(svg.xpath('//polygon/@points').first.value).to eq '2416 0, 0 -2410, -2425 0, 0 2429'
      end

      def parse_xml str
        doc = Nokogiri::XML(str)
        doc.remove_namespaces!
      end
    end
  end
end
