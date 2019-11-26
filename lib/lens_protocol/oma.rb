module LensProtocol
  # The API layer of the library.
  module OMA
    module_function

    def parse *args
      Parser.new.parse *args
    end
  end
end
