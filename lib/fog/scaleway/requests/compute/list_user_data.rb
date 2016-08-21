module Fog
  module Scaleway
    class Compute
      class Real
        def list_user_data(server_id)
          get("/servers/#{server_id}/user_data")
        end
      end

      class Mock
        def list_user_data(server_id)
          server = lookup(:servers, server_id)

          user_data = data[:user_data][server['id']].keys

          response(status: 200, body: { 'user_data' => user_data })
        end
      end
    end
  end
end
