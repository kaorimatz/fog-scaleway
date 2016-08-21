module Fog
  module Scaleway
    class Account
      class Real
        def get_user(user_id)
          get("/users/#{user_id}")
        end
      end

      class Mock
        def get_user(user_id)
          user = lookup(:users, user_id)

          response(status: 200, body: { 'user' => user })
        end
      end
    end
  end
end
