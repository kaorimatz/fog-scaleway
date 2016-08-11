module Fog
  module Scaleway
    module Errors
      def self.decode_error(error)
        body = begin
                 Fog::JSON.decode(error.response.body)
               rescue Fog::JSON::DecodeError
                 nil
               end

        return if body.nil?

        type    = body['type']
        message = body['message']
        fields  = body['fields']

        return if type.nil? || message.nil?

        unless fields.nil?
          message << "\n"
          message << format_fields(fields)
        end

        { type: type, message: message }
      end

      def self.format_fields(fields)
        fields.map { |field, msgs| format_field(field, msgs) }.join("\n")
      end

      def self.format_field(field, msgs)
        msgs = msgs.map { |msg| "\t\t- #{msg}" }
        "\t#{field}:\n#{msgs.join("\n")}"
      end
    end
  end
end
