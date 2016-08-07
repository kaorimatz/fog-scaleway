module Fog
  module Scaleway
    class Compute
      class SecurityGroups < Fog::Collection
        model Fog::Scaleway::Compute::SecurityGroup

        def all
          security_groups = service.list_security_groups.body['security_groups'] || []
          load(security_groups)
        end

        def get(identity)
          if (security_group = service.get_security_group(identity).body['security_group'])
            new(security_group)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
