module Fog
  module Scaleway
    class Compute
      class Real
        def create_security_group_rule(security_group_id, action, direction, ip_range, protocol, dest_port_from = nil)
          create("/security_groups/#{security_group_id}/rules", action: action,
                                                                direction: direction,
                                                                ip_range: ip_range,
                                                                protocol: protocol,
                                                                dest_port_from: dest_port_from)
        end
      end

      class Mock
        def create_security_group_rule(security_group_id, action, direction, ip_range, protocol, dest_port_from = nil)
          body = {
            action: action,
            direction: direction,
            ip_range: ip_range,
            protocol: protocol,
            dest_port_from: dest_port_from
          }

          body = jsonify(body)

          rules = data[:security_group_rules][security_group_id].values

          position = (rules.map { |r| r[:position] }.max || 0) + 1

          rule = {
            'direction' => body['direction'],
            'protocol' => body['protocol'],
            'ip_range' => body['ip_range'],
            'dest_port_from' => body['dest_port_from'],
            'action' => body['action'],
            'position' => position,
            'dest_port_to' => nil,
            'editable' => nil,
            'id' => Fog::UUID.uuid
          }

          data[:security_group_rules][security_group_id][rule['id']] = rule

          response(status: 201, body: { 'rule' => rule })
        end
      end
    end
  end
end
