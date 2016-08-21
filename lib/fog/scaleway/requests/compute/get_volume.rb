module Fog
  module Scaleway
    class Compute
      class Real
        def get_volume(volume_id)
          get("/volumes/#{volume_id}")
        end
      end

      class Mock
        def get_volume(volume_id)
          volume = lookup(:volumes, volume_id)

          response(status: 200, body: { 'volume' => volume })
        end
      end
    end
  end
end
