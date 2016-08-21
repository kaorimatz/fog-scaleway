module Fog
  module Scaleway
    class Compute
      class Real
        def update_snapshot(snapshot_id, body)
          update("/snapshots/#{snapshot_id}", body)
        end
      end

      class Mock
        def update_snapshot(snapshot_id, body)
          body = jsonify(body)

          snapshot = lookup(:snapshots, snapshot_id)

          snapshot['modification_date'] = now
          snapshot['name'] = body['name']

          response(status: 200, body: { 'snapshot' => snapshot })
        end
      end
    end
  end
end
