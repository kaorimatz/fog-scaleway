module Fog
  module Scaleway
    class Compute
      class Real
        def delete_ip(ip_id)
          delete("/ips/#{ip_id}")
        end
      end

      class Mock
        def delete_ip(ip_id)
          ip = lookup(:ips, ip_id)

          data[:ips].delete(ip['id'])

          if ip['server']
            server = lookup(:servers, ip['server']['id'])

            server['public_ip'] = if server['dynamic_ip_required']
                                    create_dynamic_ip
                                  end
          end

          response(status: 204)
        end
      end
    end
  end
end
