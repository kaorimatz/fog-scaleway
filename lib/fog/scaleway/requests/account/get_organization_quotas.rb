module Fog
  module Scaleway
    class Account
      class Real
        def get_organization_quotas(organization_id)
          get("/organizations/#{organization_id}/quotas")
        end
      end
    end
  end
end
