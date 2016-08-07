module Fog
  module Scaleway
    class Account
      class Real
        def delete_token(token_id)
          delete("/tokens/#{token_id}")
        end
      end
    end
  end
end
