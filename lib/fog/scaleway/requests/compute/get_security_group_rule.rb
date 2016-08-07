module Fog
  module Scaleway
    class Compute
      class Real
        def get_security_group_rule(security_group_id, rule_id)
          get("/security_groups/#{security_group_id}/rules/#{rule_id}")
        end
      end
    end
  end
end
