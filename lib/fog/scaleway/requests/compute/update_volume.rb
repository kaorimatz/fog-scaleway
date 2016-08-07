module Fog
  module Scaleway
    class Compute
      class Real
        def update_volume(volume_id, body)
          update("/volumes/#{volume_id}", body)
        end
      end
    end
  end
end
