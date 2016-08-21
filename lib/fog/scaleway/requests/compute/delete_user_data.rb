module Fog
  module Scaleway
    class Compute
      class Real
        def delete_user_data(server_id, key)
          delete("/servers/#{server_id}/user_data/#{key}")
        end
      end

      class Mock
        def delete_user_data(server_id, key)
          server = lookup(:servers, server_id)

          data[:user_data][server['id']].delete(key)

          response(status: 204)
        end
      end
    end
  end
end
