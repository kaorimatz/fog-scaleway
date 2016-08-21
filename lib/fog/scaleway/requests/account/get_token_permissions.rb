module Fog
  module Scaleway
    class Account
      class Real
        def get_token_permissions(token_id)
          get("/tokens/#{token_id}/permissions")
        end
      end

      class Mock
        def get_token_permission(token_id)
          token = lookup(:tokens, token_id)

          permissions = lookup(:token_permissions, token['id'])

          response(status: 200, body: { 'permissions' => permissions })
        end
      end
    end
  end
end
