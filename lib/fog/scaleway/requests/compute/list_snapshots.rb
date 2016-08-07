module Fog
  module Scaleway
    class Compute
      class Real
        def list_snapshots
          get('/snapshots')
        end
      end
    end
  end
end
