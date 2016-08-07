module Fog
  module Scaleway
    class Account
      class Real
        def update_token(token_id, options = {})
          request(method: :patch,
                  path: "/tokens/#{token_id}",
                  body: options,
                  expects: [200])
        end
      end
    end
  end
end
