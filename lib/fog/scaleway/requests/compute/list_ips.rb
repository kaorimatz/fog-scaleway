module Fog
  module Scaleway
    class Compute
      class Real
        def list_ips
          get('/ips')
        end
      end
    end
  end
end
