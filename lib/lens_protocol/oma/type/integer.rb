module LensProtocol
  module OMA
    module Type
      class Integer < Base
        def parse message, label, values, _opts
          values = values.map { |str| Integer(str) rescue nil }
          super
        end
      end
    end
  end
end
