module Fog
  module Scaleway
    class Compute
      class Real
        def create_security_group(name, options = {})
          body = {
            organization: @organization,
            name: name
          }

          body.merge!(options)

          create('/security_groups', body)
        end
      end

      class Mock
        def create_security_group(name, options = {})
          body = {
            organization: @organization,
            name: name
          }

          body.merge!(options)

          body = jsonify(body)

          security_group = {
            'description' => body['description'],
            'enable_default_security' => body.fetch('enable_default_security', true),
            'servers' => [],
            'organization' => body['organization'],
            'organization_default' => body.fetch('organization_default', false),
            'id' => Fog::UUID.uuid,
            'name' => body['name']
          }

          if security_group['organization_default'] && default_security_group
            raise_conflict('Cannot have more than one organization default group')
          end

          data[:security_groups][security_group['id']] = security_group

          response(status: 201, body: { 'security_group' => security_group })
        end
      end
    end
  end
end
