module Fog
  module Scaleway
    class Compute
      class Real
        def execute_server_action(server_id, action)
          request(method: :post,
                  path: "/servers/#{server_id}/action",
                  body: {
                    action: action
                  },
                  expects: [202])
        end
      end
    end
  end
end
