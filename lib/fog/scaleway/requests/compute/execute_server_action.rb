module Fog
  module Scaleway
    class Compute
      class Real
        def execute_server_action(server_id, action)
          request(method: :post,
                  path: "/servers/#{server_id}/action",
                  body: {
                    action: action
                  },
                  expects: [202])
        end
      end

      class Mock
        def execute_server_action(server_id, action)
          server = lookup(:servers, server_id)

          started_at = now

          task = {
            'status' => 'pending',
            'terminated_at' => nil,
            'href_from' => "/servers/#{server_id}/action",
            'progress' => 0,
            'started_at' => started_at,
            'id' => Fog::UUID.uuid
          }

          case action
          when 'poweron'
            unless server['state'] == 'stopped'
              raise_invalid_request_error('server should be stopped')
            end

            task['description'] = 'server_batch_poweron'

            if server['enable_ipv6']
              server['ipv6'] = create_ipv6
            end

            server['location'] = {
              'platform_id' => Fog::Mock.random_numbers(2),
              'node_id' => Fog::Mock.random_numbers(2),
              'cluster_id' => Fog::Mock.random_numbers(2),
              'chassis_id' => Fog::Mock.random_numbers(2)
            }

            server['private_ip'] = Fog::Mock.random_ip

            if server['dynamic_ip_required'] && server['public_ip'].nil?
              server['public_ip'] = create_dynamic_ip
            end

            server['state'] = 'starting'
            server['state_detail'] = 'provisioning node'
            server['modification_date'] = started_at
          when 'poweroff'
            if server['state'] == 'stopping'
              raise_invalid_request_error('server is being stopped or rebooted')
            elsif server['state'] != 'running'
              raise_invalid_request_error('server should be running')
            end

            task['description'] = 'server_poweroff'

            server['state'] = 'stopping'
            server['state_detail'] = 'stopping'
            server['modification_date'] = started_at
          when 'reboot'
            if server['state'] == 'stopping'
              raise_invalid_request_error('server is being stopped or rebooted')
            elsif server['state'] != 'running'
              raise_invalid_request_error('server should be running')
            end

            task['description'] = 'server_reboot'

            server['state'] = 'stopping'
            server['state_detail'] = 'rebooting'
            server['modification_date'] = started_at
          when 'terminate'
            if server['state'] == 'stopping'
              raise_invalid_request_error('server is being stopped or rebooted')
            elsif server['state'] != 'running'
              raise_invalid_request_error('server should be running')
            end

            task['description'] = 'server_terminate'

            server['state'] = 'stopping'
            server['state_detail'] = 'terminating'
            server['modification_date'] = started_at
          end

          data[:tasks][task['id']] = task

          response(status: 202, body: { 'task' => task })
        end
      end
    end
  end
end
