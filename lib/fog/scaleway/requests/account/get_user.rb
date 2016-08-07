module Fog
  module Scaleway
    class Account
      class Real
        def get_user(user_id)
          get("/users/#{user_id}")
        end
      end
    end
  end
end
