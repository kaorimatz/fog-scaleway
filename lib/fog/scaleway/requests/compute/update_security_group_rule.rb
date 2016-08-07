module Fog
  module Scaleway
    class Compute
      class Real
        def update_security_group_rule(security_group_id, rule_id, body)
          update("/security_groups/#{security_group_id}/rules/#{rule_id}", body)
        end
      end
    end
  end
end
