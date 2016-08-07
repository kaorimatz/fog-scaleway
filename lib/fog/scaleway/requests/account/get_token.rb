module Fog
  module Scaleway
    class Account
      class Real
        def get_token(token_id)
          get("/tokens/#{token_id}")
        end
      end
    end
  end
end
