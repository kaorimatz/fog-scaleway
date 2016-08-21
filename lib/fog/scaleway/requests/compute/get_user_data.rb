module Fog
  module Scaleway
    class Compute
      class Real
        def get_user_data(server_id, key)
          get("/servers/#{server_id}/user_data/#{key}")
        end
      end

      class Mock
        def get_user_data(server_id, key)
          server = lookup(:servers, server_id)

          user_data = data[:user_data][server['id']][key]

          raise Excon::Error::NotFound unless user_data

          response(status: 200,
                   headers: { 'Content-Type' => 'text/plain' },
                   body: user_data)
        end
      end
    end
  end
end
