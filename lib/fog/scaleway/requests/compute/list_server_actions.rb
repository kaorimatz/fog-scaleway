module Fog
  module Scaleway
    class Compute
      class Real
        def list_server_actions(server_id)
          get("/servers/#{server_id}/action")
        end
      end

      class Mock
        def list_server_actions(server_id)
          server = lookup(:servers, server_id)

          actions = data[:server_actions][server['id']]

          response(status: 200, body: { 'actions' => actions })
        end
      end
    end
  end
end
