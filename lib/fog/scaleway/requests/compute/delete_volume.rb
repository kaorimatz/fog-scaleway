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

          if volume['server']
            raise_invalid_request_error('a server is attached to this volume')
          end

          data[:volumes].delete(volume_id)

          data[:snapshots].each_value do |snapshot|
            if snapshot['base_volume'] && snapshot['base_volume']['id'] == volume_id
              snapshot['base_volume'] = nil
            end
          end

          response(status: 204)
        end
      end
    end
  end
end
