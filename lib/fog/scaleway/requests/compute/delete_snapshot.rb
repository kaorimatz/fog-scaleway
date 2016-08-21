module Fog
  module Scaleway
    class Compute
      class Real
        def delete_snapshot(snapshot_id)
          delete("/snapshots/#{snapshot_id}")
        end
      end

      class Mock
        def delete_snapshot(snapshot_id)
          snapshot = lookup(:snapshots, snapshot_id)

          in_use = data[:images].any? do |_id, image|
            image['root_volume']['id'] == snapshot['id']
          end

          if in_use
            raise_invalid_request_error('one or more images are attached to this snapshot')
          end

          data[:snapshots].delete(snapshot['id'])

          response(status: 204)
        end
      end
    end
  end
end
