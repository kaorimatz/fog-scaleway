module Fog
  module Scaleway
    class Compute
      class Real
        def get_volume(volume_id)
          get("/volumes/#{volume_id}")
        end
      end
    end
  end
end
