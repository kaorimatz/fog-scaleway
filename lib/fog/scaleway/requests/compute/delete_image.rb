module Fog
  module Scaleway
    class Compute
      class Real
        def delete_image(image_id)
          delete("/images/#{image_id}")
        end
      end

      class Mock
        def delete_image(image_id)
          image = lookup(:images, image_id)

          data[:images].delete(image['id'])

          data[:servers].each_value do |server|
            if server['image'] && server['image']['id'] == image['id']
              server['image'] = nil
            end
          end

          response(status: 204)
        end
      end
    end
  end
end
