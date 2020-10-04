module Fog
  module Scaleway
    class Compute
      class Real
        def delete_volume(volume_id)
          delete("/volumes/#{volume_id}")
        end
      end

      class Mock
        def delete_volume(volume_id)
          volume = lookup(:volumes, volume_id)

          raise_invalid_request_error('a server is attached to this volume') if volume['server']

          data[:volumes].delete(volume_id)

          data[:snapshots].each_value do |snapshot|
            snapshot['base_volume'] = nil if snapshot['base_volume'] && snapshot['base_volume']['id'] == volume_id
          end

          response(status: 204)
        end
      end
    end
  end
end
