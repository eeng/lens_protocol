module LensProtocol
  module OMA
    class Builder
      def build hash, types: {}
        types = TYPES.merge(types)

        hash.reduce Message.new do |message, (label, value)|
          wrapped_value = types[label].wrap(value, hash, label)
          if wrapped_value == :ignored
            message
          else
            message.add_record(label, wrapped_value)
          end
        end
      end
    end
  end
end
