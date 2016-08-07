module Fog
  module Scaleway
    class Compute
      class Real
        def delete_security_group_rule(security_group_id, rule_id)
          delete("/security_groups/#{security_group_id}/rules/#{rule_id}")
        end
      end
    end
  end
end
