module Fog
  module Scaleway
    class Compute
      class Real
        def delete_user_data(server_id, key)
          delete("/servers/#{server_id}/user_data/#{key}")
        end
      end
    end
  end
end
