module Fog
  module Scaleway
    class Compute
      class Real
        def delete_ip(ip_id)
          delete("/ips/#{ip_id}")
        end
      end
    end
  end
end
