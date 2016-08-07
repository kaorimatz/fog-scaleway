module Fog
  module Scaleway
    class Compute
      class Real
        def delete_server(server_id)
          delete("/servers/#{server_id}")
        end
      end
    end
  end
end
