module Fog
  module Scaleway
    class Compute
      class Real
        def delete_server(server_id)
          delete("/servers/#{server_id}")
        end
      end

      class Mock
        def delete_server(server_id)
          server = lookup(:servers, server_id)

          if server['state'] != 'stopped'
            raise_invalid_request_error('server should be stopped')
          end

          data[:servers].delete(server['id'])

          data[:user_data].delete(server['id'])

          data[:server_actions].delete(server['id'])

          if server['public_ip'] && !server['public_ip']['dynamic']
            ip = lookup(:ips, server['public_ip']['id'])
            ip['server'] = nil
          end

          security_group = lookup(:security_groups, server['security_group']['id'])
          security_group['servers'].reject! { |s| s['id'] == server['id'] }

          volumes = server['volumes'].values
          volumes.each { |volume| volume['server'] = nil }

          response(status: 204)
        end
      end
    end
  end
end
