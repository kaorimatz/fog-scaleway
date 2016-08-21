module Fog
  module Scaleway
    class Compute
      class Real
        def get_server(server_id)
          get("/servers/#{server_id}")
        end
      end

      class Mock
        def get_server(server_id)
          server = lookup(:servers, server_id)

          elapsed_time = Time.now - Time.parse(server['modification_date'])

          if server['state'] == 'starting' && elapsed_time >= Fog::Mock.delay
            server['state'] = 'running'
            server['state_detail'] = 'booted'
            server['modification_date'] = now
          elsif server['state'] == 'stopping' && elapsed_time >= Fog::Mock.delay
            case server['state_detail']
            when 'stopping'
              server['ipv6'] = nil
              server['location'] = nil
              server['private_ip'] = nil

              if server['public_ip'] && server['public_ip']['dynamic']
                server['public_ip'] = nil
              end

              server['state'] = 'stopped'
              server['state_detail'] = ''
              server['modification_date'] = now
            when 'rebooting'
              server['state'] = 'running'
              server['state_detail'] = 'booted'
              server['modification_date'] = now
            when 'terminating'
              terminate_server(server)
            end
          end

          response(status: 200, body: { 'server' => server })
        end
      end
    end
  end
end
