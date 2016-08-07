module Fog
  module Scaleway
    class Compute
      class Real
        def list_security_group_rules(security_group_id)
          get("/security_groups/#{security_group_id}/rules")
        end
      end
    end
  end
end
