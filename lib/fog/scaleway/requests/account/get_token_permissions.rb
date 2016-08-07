module Fog
  module Scaleway
    class Account
      class Real
        def get_token_permissions(token_id)
          get("/tokens/#{token_id}/permissions")
        end
      end
    end
  end
end
