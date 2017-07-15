module Fog
  module Scaleway
    class Compute
      class Real
        def update_server(server_id, body)
          update("/servers/#{server_id}", body)
        end
      end

      class Mock
        def update_server(server_id, body)
          body = jsonify(body)

          server = lookup(:servers, server_id)

          bootscript = if body['bootscript'].is_a?(Hash)
                         lookup(:bootscripts, body['bootscript']['id'])
                       elsif body['bootscript'].is_a?(String)
                         lookup(:bootscripts, body['bootscript'])
                       end

          _, product_server = lookup_product_server(server['commercial_type'])

          if body['enable_ipv6'] && !product_server['network']['ipv6_support']
            raise_invalid_request_error("Cannot enable ipv6 on #{commercial_type}")
          end

          volumes = {}
          body['volumes'].each do |index, volume|
            volume = lookup(:volumes, volume['id'])

            if volume['server'] && volume['server']['id'] != server['id']
              message = "volume #{volume['id']} is already attached to a server"
              raise_invalid_request_error(message)
            end

            volumes[index] = volume
          end

          server['bootscript'] = bootscript if bootscript
          server['dynamic_ip_required'] = body['dynamic_ip_required']
          server['enable_ipv6'] = body['enable_ipv6']
          server['hostname'] = body['name']
          server['modification_date'] = now
          server['name'] = body['name']
          server['tags'] = body['tags']
          server['volumes'] = volumes

          if server['dynamic_ip_required'] && server['state'] == 'running'
            server['public_ip'] ||= create_dynamic_ip
          elsif !server['dynamic_ip_required'] && server['public_ip'] && server['public_ip']['dynamic']
            server['public_ip'] = nil
          end

          if server['enable_ipv6'] && server['state'] == 'running'
            server['ipv6'] ||= create_ipv6
          elsif !server['enable_ipv6']
            server['ipv6'] = nil
          end

          data[:volumes].each do |id, volume|
            if server['volumes'].any? { |_i, v| v['id'] == id }
              volume['server'] = {
                'id' => server['id'],
                'name' => server['name']
              }
            elsif volume['server'] && volume['server']['id'] == server['id']
              volume['server'] = nil
            end
          end

          response(status: 200, body: { 'server' => server })
        end
      end
    end
  end
end
