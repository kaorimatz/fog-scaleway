module Fog
  module Scaleway
    class Compute
      class Real
        def get_image(image_id)
          get("/images/#{image_id}")
        end
      end

      class Mock
        def get_image(image_id)
          image = lookup(:images, image_id)

          response(status: 200, body: { 'image' => image })
        end
      end
    end
  end
end
