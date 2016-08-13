module Fog
  module Scaleway
    class Compute
      class Real
        def list_user_data(server_id)
          get("/servers/#{server_id}/user_data")
        end
      end
    end
  end
end
