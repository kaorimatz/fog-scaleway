module Fog
  module Scaleway
    class Compute
      class Real
        def get_ip(ip_id)
          get("/ips/#{ip_id}")
        end
      end
    end
  end
end
