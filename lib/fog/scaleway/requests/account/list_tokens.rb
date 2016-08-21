module Fog
  module Scaleway
    class Account
      class Real
        def list_tokens
          get('/tokens')
        end
      end

      class Mock
        def list_tokens
          tokens = data[:tokens].values

          response(status: 200, body: { 'tokens' => tokens })
        end
      end
    end
  end
end
