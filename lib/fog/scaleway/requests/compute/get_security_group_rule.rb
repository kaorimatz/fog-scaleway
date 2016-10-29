module Fog
  module Scaleway
    class Compute
      class Real
        def get_security_group_rule(security_group_id, rule_id)
          get("/security_groups/#{security_group_id}/rules/#{rule_id}")
        end
      end

      class Mock
        def get_security_group_rule(security_group_id, rule_id)
          security_group = lookup(:security_groups, security_group_id)

          rule = data[:security_group_rules][security_group['id']][rule_id]

          raise_unknown_resource(rule_id) unless rule

          response(status: 200, body: { 'rule' => rule })
        end
      end
    end
  end
end
