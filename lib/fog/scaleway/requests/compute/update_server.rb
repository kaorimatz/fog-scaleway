module Fog
  module Scaleway
    class Compute
      class Real
        def update_server(server_id, body)
          update("/servers/#{server_id}", body)
        end
      end
    end
  end
end
