module Fog
  module Scaleway
    class Compute
      class Real
        def get_snapshot(snapshot_id)
          get("/snapshots/#{snapshot_id}")
        end
      end
    end
  end
end
