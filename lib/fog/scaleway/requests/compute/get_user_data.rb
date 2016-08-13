module Fog
  module Scaleway
    class Compute
      class Real
        def get_user_data(server_id, key)
          get("/servers/#{server_id}/user_data/#{key}")
        end
      end
    end
  end
end
