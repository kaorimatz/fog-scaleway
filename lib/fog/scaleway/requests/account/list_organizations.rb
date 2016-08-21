module Fog
  module Scaleway
    class Account
      class Real
        def list_organizations
          get('/organizations')
        end
      end

      class Mock
        def list_organizations
          organizations = data[:organizations].values

          response(status: 200, body: { 'organizations' => organizations })
        end
      end
    end
  end
end
