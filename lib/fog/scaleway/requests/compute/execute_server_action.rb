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

            total_volume_size = server['volumes'].values.map { |v| v['size'] }.reduce(&:+)
            commercial_type, product_server = lookup_product_server(server['commercial_type'])
            # rubocop:disable Metrics/BlockNesting
            if (constraint = product_server['volumes_constraint'])
              min_size = constraint['min_size'] || -Float::INFINITY
              max_size = constraint['max_size'] || Float::INFINITY
              if total_volume_size < min_size || total_volume_size > max_size
                message = "The total volume size of #{commercial_type} instances must be "
                message << if min_size == -Float::INFINITY
                             "equal or below #{max_size / 10**9}GB"
                           elsif max_size == Float::INFINITY
                             "equal or above #{min_size / 10**9}GB"
                           else
                             "between #{min_size / 10**9}GB and #{max_size / 10**9}GB"
                           end
                raise_invalid_request_error(message)
              end
            end
            # rubocop:enable Metrics/BlockNesting

            task['description'] = 'server_batch_poweron'

            server['ipv6'] = create_ipv6 if server['enable_ipv6']

            server['location'] = {
              'platform_id' => Fog::Mock.random_numbers(2),
              'node_id' => Fog::Mock.random_numbers(2),
              'cluster_id' => Fog::Mock.random_numbers(2),
              'zone_id' => @region,
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
