module Fog
  module Scaleway
    class Client
      def initialize(endpoint, token, connection_options)
        @endpoint           = endpoint
        @token              = token
        @connection_options = connection_options
      end

      def request(params)
        params[:headers] ||= {}
        params[:headers]['Content-Type'] ||= 'application/json'
        params[:headers]['X-Auth-Token'] ||= @token

        params[:body] = encode_body(params)

        response = connection.request(params)

        response.body = decode_body(response)

        response
      end

      private

      def connection
        @connection ||= Fog::Core::Connection.new(@endpoint, false, @connection_options)
      end

      def encode_body(params)
        body         = params[:body]
        content_type = params[:headers]['Content-Type']

        if body.nil? || body.is_a?(String)
          body
        elsif content_type =~ %r{application/json.*}i
          Fog::JSON.encode(body)
        else
          body.to_s
        end
      end

      def decode_body(response)
        body         = response.body
        content_type = response.headers['Content-Type']

        if !body.nil? && !body.empty? && content_type =~ %r{application/json.*}i
          Fog::JSON.decode(body)
        else
          body
        end
      end
    end
  end
end
