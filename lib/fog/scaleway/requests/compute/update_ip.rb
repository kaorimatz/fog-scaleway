module Fog
  module Scaleway
    class Compute
      class Real
        def update_ip(ip_id, body)
          update("/ips/#{ip_id}", body)
        end
      end

      class Mock
        def update_ip(ip_id, body)
          body = jsonify(body)

          ip = lookup(:ips, ip_id)

          server = nil
          if (server_id = body['server'])
            server = lookup(:servers, server_id)

            if server['public_ip'] && !server['public_ip']['dynamic']
              message = "Server '#{server['id']}' is already attached to an IP address"
              raise_invalid_request_error(message)
            end

            server = {
              'id' => server['id'],
              'name' => server['name']
            }
          end

          ip['reverse'] = body['reverse']
          ip['server'] = server

          if server
            server['public_ip'] = {
              'dynamic' => false,
              'id' => ip['id'],
              'address' => ip['address']
            }
          end

          response(status: 200, body: { 'ip' => ip })
        end
      end
    end
  end
end
