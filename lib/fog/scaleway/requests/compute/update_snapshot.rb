module Fog
  module Scaleway
    class Compute
      class Real
        def update_snapshot(snapshot_id, body)
          update("/snapshots/#{snapshot_id}", body)
        end
      end
    end
  end
end
