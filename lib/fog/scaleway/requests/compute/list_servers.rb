module Fog
  module Scaleway
    class Compute
      class Real
        def list_servers
          get('/servers')
        end
      end
    end
  end
end
