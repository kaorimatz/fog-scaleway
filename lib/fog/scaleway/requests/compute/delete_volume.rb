module Fog
  module Scaleway
    class Compute
      class Real
        def delete_volume(volume_id)
          delete("/volumes/#{volume_id}")
        end
      end
    end
  end
end
