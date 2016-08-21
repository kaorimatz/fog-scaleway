module Fog
  module Scaleway
    class Account
      class Real
        def get_token(token_id)
          get("/tokens/#{token_id}")
        end
      end

      class Mock
        def get_token(token_id)
          token = lookup(:tokens, token_id)

          response(status: 200, body: { 'token' => token })
        end
      end
    end
  end
end
