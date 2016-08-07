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
    end
  end
end
