module Fog
  module Scaleway
    class Account
      class Real
        def update_user(user_id, options = {})
          request(method: :patch,
                  path: "/users/#{user_id}",
                  body: options,
                  expects: [200])
        end
      end
    end
  end
end
