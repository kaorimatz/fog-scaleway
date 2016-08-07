module Fog
  module Scaleway
    class Compute
      class Real
        def get_server(server_id)
          get("/servers/#{server_id}")
        end
      end
    end
  end
end
