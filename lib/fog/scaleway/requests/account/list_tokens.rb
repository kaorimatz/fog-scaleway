module Fog
  module Scaleway
    class Account
      class Real
        def list_tokens
          get('/tokens')
        end
      end
    end
  end
end
