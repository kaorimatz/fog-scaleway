module Fog
  module Scaleway
    class Compute
      class Real
        def update_ip(ip_id, body)
          update("/ips/#{ip_id}", body)
        end
      end
    end
  end
end
