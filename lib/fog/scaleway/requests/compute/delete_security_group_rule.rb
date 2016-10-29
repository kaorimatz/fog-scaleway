module Fog
  module Scaleway
    class Compute
      class Real
        def delete_security_group_rule(security_group_id, rule_id)
          delete("/security_groups/#{security_group_id}/rules/#{rule_id}")
        end
      end

      class Mock
        def delete_security_group_rule(security_group_id, rule_id)
          security_group = lookup(:security_groups, security_group_id)

          unless data[:security_group_rules][security_group['id']].delete(rule_id)
            raise_unknown_resource(rule_id)
          end

          response(status: 204)
        end
      end
    end
  end
end
