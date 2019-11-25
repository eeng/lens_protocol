module LensProtocol
  class Error < StandardError
  end

  class ParsingError < Error
    def initialize line, msg
      super "#{msg}\n  Line: #{line}"
    end
  end
end
