module Fog
  module Scaleway
    class Compute
      class Real
        def update_image(image_id, body)
          update("/images/#{image_id}", body)
        end
      end
    end
  end
end
