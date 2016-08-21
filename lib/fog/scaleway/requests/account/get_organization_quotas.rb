module Fog
  module Scaleway
    class Account
      class Real
        def get_organization_quotas(organization_id)
          get("/organizations/#{organization_id}/quotas")
        end
      end

      class Mock
        def get_organization_quotas(organization_id)
          organization = lookup(:organizations, organization_id)

          quotas = lookup(:organization_quotas, organization['id'])

          response(status: 200, body: { 'quotas' => quotas })
        end
      end
    end
  end
end
