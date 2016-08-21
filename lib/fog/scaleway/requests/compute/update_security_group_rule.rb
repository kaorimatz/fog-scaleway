module Fog
  module Scaleway
    class Compute
      class Real
        def update_security_group_rule(security_group_id, rule_id, body)
          update("/security_groups/#{security_group_id}/rules/#{rule_id}", body)
        end
      end

      class Mock
        def update_security_group_rule(security_group_id, rule_id, body)
          body = jsonify(body)

          security_group = lookup(:security_groups, security_group_id)

          rule = data[:security_group_rules][security_group['id']][rule_id]

          raise_unknown_resource(rule_id) unless rule

          rule['action'] = body['action']
          rule['dest_port_from'] = body['dest_port_from']
          rule['direction'] = body['direction']
          rule['ip_range'] = body['ip_range']
          rule['protocol'] = body['protocol']

          response(status: 201, body: { 'rule' => rule })
        end
      end
    end
  end
end
