module LensProtocol
  module SVG
    module_function

    def from_message message, **opts
      message
        .tracing_in_rectangular_coordinates
        .select(&:any?)
        .map { |coordinates| from_rectangular_coordinates coordinates, **opts }
    end

    def from_rectangular_coordinates coordinates, polygon: {}, cross: {}, cross_size: 200
      polygon_opts = {
        'stroke-width' => 50,
        'points' => polygon_points_from_coordinates(coordinates)
      }.merge(polygon)

      cross_opts = {
        'stroke-width' => 20
      }.merge(cross)

      Nokogiri::XML::Builder.new do |xml|
        xml.svg(width: '100%', viewBox: view_box_from_coordinates(coordinates), xmlns: 'http://www.w3.org/2000/svg') do |xml|
          xml.polygon polygon_opts
          xml.line cross_opts.merge(x1: 0, y1: -cross_size, x2: 0, y2: cross_size)
          xml.line cross_opts.merge(x1: -cross_size, y1: 0, x2: cross_size, y2: 0)
        end
      end.doc.root.to_s
    end

    # @param coordinates [Array] in rectangular form (+X to the right and +Y to the top)
    def polygon_points_from_coordinates coordinates
      coordinates.map { |(x, y)| [x.round, -y.round].join(' ') }.join(', ')
    end

    def view_box_from_coordinates coordinates
      if coordinates.any?
        # Double the max coordinates plus a 10% to leave some margin for the border
        width = coordinates.map { |(x, _)| x.abs }.max * 2.1
        height = coordinates.map { |(_, y)| y.abs }.max * 2.1
        [-width / 2, -height / 2, width, height].join ' '
      end
    end
  end
end
