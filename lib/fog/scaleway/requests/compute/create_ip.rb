module Fog
  module Scaleway
    class Compute
      class Real
        def create_ip(options = {})
          body = {
            organization: @organization
          }

          body.merge!(options)

          create('/ips', body)
        end
      end

      class Mock
        def create_ip(options = {})
          body = {
            organization: @organization
          }

          body.merge!(options)

          body = jsonify(body)

          server = lookup(:servers, body['server']) if body['server']

          ip = {
            'organization' => body['organization'],
            'reverse' => nil,
            'id' => Fog::UUID.uuid,
            'server' => nil,
            'address' => Fog::Mock.random_ip
          }

          if server
            ip['server'] = {
              'id' => server['id'],
              'name' => server['name']
            }
          end

          if server && (public_ip = server['public_ip'])
            if public_ip['dynamic']
              ip['id'] = public_ip['id']
              ip['address'] = public_ip['address']
            else
              message = "Server '#{server['id']}' is already attached to an IP address"
              raise_invalid_request_error(message)
            end
          end

          data[:ips][ip['id']] = ip

          if server
            server['public_ip'] = {
              'dynamic' => false,
              'id' => ip['id'],
              'address' => ip['address']
            }
          end

          response(status: 201, body: { 'ip' => ip })
        end
      end
    end
  end
end
