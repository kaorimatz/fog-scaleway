module Fog
  module Scaleway
    class Account
      class Real
        def list_organizations
          get('/organizations')
        end
      end
    end
  end
end
