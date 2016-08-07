module Fog
  module Scaleway
    class Compute
      class Real
        def delete_image(image_id)
          delete("/images/#{image_id}")
        end
      end
    end
  end
end
