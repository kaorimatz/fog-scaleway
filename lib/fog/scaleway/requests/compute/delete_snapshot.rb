module Fog
  module Scaleway
    class Compute
      class Real
        def delete_snapshot(snapshot_id)
          delete("/snapshots/#{snapshot_id}")
        end
      end
    end
  end
end
