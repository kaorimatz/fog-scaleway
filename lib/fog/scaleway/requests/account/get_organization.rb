module Fog
  module Scaleway
    class Account
      class Real
        def get_organization(organization_id)
          get("/organizations/#{organization_id}")
        end
      end
    end
  end
end
