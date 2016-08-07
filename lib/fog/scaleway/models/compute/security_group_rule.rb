module Fog
  module Scaleway
    class Compute
      class SecurityGroupRule < Fog::Model
        attr_accessor :security_group

        identity :id

        attribute :action
        attribute :dest_port_from
        attribute :dest_port_to
        attribute :direction
        attribute :editable
        attribute :ip_range
        attribute :position
        attribute :protocol

        def save
          if persisted?
            update
          else
            create
          end
        end

        def destroy
          requires :security_group, :identity

          service.delete_security_group_rule(security_group.identity, identity)
          true
        end

        private

        def create
          requires :security_group, :action, :direction, :ip_range, :protocol

          if (rule = service.create_security_group_rule(security_group.identity, action, direction, ip_range, protocol, dest_port_from).body['rule'])
            merge_attributes(rule)
            true
          else
            false
          end
        end

        def update
          requires :security_group, :identity

          if (rule = service.update_security_group_rule(security_group.identity, identity, self).body['rule'])
            merge_attributes(rule)
            true
          else
            false
          end
        end
      end
    end
  end
end
