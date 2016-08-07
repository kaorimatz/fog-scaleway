module Fog
  module Scaleway
    class Compute
      class Real
        def list_volumes
          get('/volumes')
        end
      end
    end
  end
end
