module Fog
  module Scaleway
    class Compute
      class Real
        def delete_security_group(security_group_id)
          delete("/security_groups/#{security_group_id}")
        end
      end

      class Mock
        def delete_security_group(security_group_id)
          security_group = lookup(:security_groups, security_group_id)

          unless security_group['servers'].empty?
            raise_conflict('Group is in use. You cannot delete it.')
          end

          if security_group['organization_default']
            raise_conflict('Group is default group. You cannot delete it.')
          end

          data[:security_groups].delete(security_group['id'])

          data[:security_group_rules].delete(security_group['id'])

          response(status: 204)
        end
      end
    end
  end
end
