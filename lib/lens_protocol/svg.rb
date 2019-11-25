module LensProtocol
  module SVG
    module_function

    def from_message message, **opts
      message.tracing_in_rectangular_coordinates.map { |coordinates| from_rectangular_coordinates coordinates, **opts }
    end

    def from_rectangular_coordinates coordinates, polygon: {}, cross_size: 10
      polygon_opts = {
        stroke: 'black',
        stroke_width: 2,
        stroke_linejoin: 'round',
        fill: 'red',
        points: polygon_points_from_coordinates(coordinates)
      }.merge(polygon)

      Nokogiri::XML::Builder.new do |xml|
        xml.svg(width: '100%', xmlns: 'http://www.w3.org/2000/svg') do |xml|
          xml.polygon polygon_opts
          xml.line x1: 0, y1: -cross_size, x2: 0, y2: cross_size
          xml.line x1: -cross_size, y1: 0, x2: cross_size, y2: 0
        end
      end.doc.root.to_s
    end

    # @param coordinates [Array] in rectangular form (+X to the right and +Y to the top)
    def polygon_points_from_coordinates coordinates
      coordinates.map { |(x, y)| [x.round, -y.round].join(' ') }.join(', ')
    end
  end
end
