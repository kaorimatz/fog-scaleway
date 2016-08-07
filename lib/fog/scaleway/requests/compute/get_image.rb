module Fog
  module Scaleway
    class Compute
      class Real
        def get_image(image_id)
          get("/images/#{image_id}")
        end
      end
    end
  end
end
