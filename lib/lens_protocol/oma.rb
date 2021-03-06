module LensProtocol
  # The API layer of the library.
  module OMA
    module_function

    def parse *args
      Parser.new.parse *args
    end

    def generate *args
      Builder.new.build *args
    end

    def format *args
      Formatter.new.format *args
    end
  end
end
