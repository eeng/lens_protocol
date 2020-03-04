module LensProtocol
  class Error < StandardError
  end

  class ParsingError < Error
    def initialize msg = 'Parsing failed', line = 'N/A'
      super "#{msg}\n  Line: #{line}"
    end
  end

  class ValidationError < Error
  end
end
