module Fog
  module Scaleway
    class Account
      class Real
        def delete_token(token_id)
          delete("/tokens/#{token_id}")
        end
      end

      class Mock
        def delete_token(token_id)
          token = lookup(:tokens, token_id)

          data[:tokens].delete(token['id'])

          response(status: 204)
        end
      end
    end
  end
end
