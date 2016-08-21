module Fog
  module Scaleway
    class Compute
      class Real
        def get_ip(ip_id)
          get("/ips/#{ip_id}")
        end
      end

      class Mock
        def get_ip(ip_id)
          ip = lookup(:ips, ip_id)

          response(status: 200, body: { 'ip' => ip })
        end
      end
    end
  end
end
