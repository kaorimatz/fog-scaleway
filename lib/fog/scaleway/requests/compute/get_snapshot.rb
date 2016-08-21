module Fog
  module Scaleway
    class Compute
      class Real
        def get_snapshot(snapshot_id)
          get("/snapshots/#{snapshot_id}")
        end
      end

      class Mock
        def get_snapshot(snapshot_id)
          snapshot = lookup(:snapshots, snapshot_id)

          response(status: 200, body: { 'snapshot' => snapshot })
        end
      end
    end
  end
end
