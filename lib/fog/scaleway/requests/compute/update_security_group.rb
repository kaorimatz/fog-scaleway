module Fog
  module Scaleway
    class Compute
      class Real
        def update_security_group(security_group_id, body)
          update("/security_groups/#{security_group_id}", body)
        end
      end

      class Mock
        def update_security_group(security_group_id, body)
          body = jsonify(body)

          security_group = lookup(:security_groups, security_group_id)

          if body['organization_default'] && default_security_group
            raise_conflict('Cannot have more than one organization default group')
          end

          security_group['description'] = body['description']
          security_group['enable_default_security'] = body['enable_default_security']
          security_group['name'] = body['name']

          response(status: 200, body: { 'security_group' => security_group })
        end
      end
    end
  end
end
