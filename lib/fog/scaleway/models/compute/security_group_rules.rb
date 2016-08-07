module Fog
  module Scaleway
    class Compute
      class SecurityGroupRules < Fog::Collection
        model Fog::Scaleway::Compute::SecurityGroupRule

        attribute :security_group

        def all
          requires :security_group

          rules = service.list_security_group_rules(security_group.identity).body['rules'] || []
          load(rules)
        end

        def get(identity)
          requires :security_group

          if (rule = service.get_security_group_rule(security_group.identity, identity).body['rule'])
            new(rule)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end

        def new(attributes = {})
          requires :security_group

          super({ security_group: security_group }.merge(attributes))
        end
      end
    end
  end
end
