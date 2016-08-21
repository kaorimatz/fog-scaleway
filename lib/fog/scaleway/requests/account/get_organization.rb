module Fog
  module Scaleway
    class Account
      class Real
        def get_organization(organization_id)
          get("/organizations/#{organization_id}")
        end
      end

      class Mock
        def get_organization(organization_id)
          organization = lookup(:organizations, organization_id)

          response(status: 200, body: { 'organization' => organization })
        end
      end
    end
  end
end
