module Fog
  module Scaleway
    class Compute
      class Real
        def list_server_actions(server_id)
          get("/servers/#{server_id}/action")
        end
      end
    end
  end
end
