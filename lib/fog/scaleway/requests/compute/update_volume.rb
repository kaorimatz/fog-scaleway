module Fog
  module Scaleway
    class Compute
      class Real
        def update_volume(volume_id, body)
          update("/volumes/#{volume_id}", body)
        end
      end

      class Mock
        def update_volume(volume_id, body)
          body = jsonify(body)

          volume = lookup(:volumes, volume_id)

          volume['modification_date'] = now
          volume['name'] = body['name']

          response(status: 200, body: { 'volume' => volume })
        end
      end
    end
  end
end
